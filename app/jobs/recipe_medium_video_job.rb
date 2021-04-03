class RecipeMediumVideoJob < ApplicationJob
  queue_as :default

  def perform(video_id, method)
    video = RecipeMedium.find_by(id: video_id)
    return unless video

    send(method, video)
  end

  private

  def process_metadata(video)
    file  = URI(video.file_url).open
    movie = FFMPEG::Movie.new(file.path)
    filename = video.file_metadata['metadata']['filename'].sub(/\.\S*$/, '.jpg')
    s3_key   = "#{video.file_metadata['storage']}/#{SecureRandom.uuid}/#{filename}"

    screenshot_obj      = BUCKET.object(s3_key)
    duration            = movie.duration.to_i
    seek_time           = duration > 9 ? 5 : duration / 2
    screenshot_filepath = Tempfile.create(filename)
    screenshot          = movie.screenshot(screenshot_filepath.path, seek_time: seek_time)
    screenshot_file     = File.open(screenshot.path)

    screenshot_obj.upload_file(screenshot_file, acl: 'public-read')

    video.video_meta = {
      width:  movie.width,
      height: movie.height,
      aspect: movie.width / movie.height.to_f,
      screenshot_key: screenshot_obj.key
    }
    video.save

    file.delete
    File.delete(screenshot_file)
  end

  def delete(videos)
    videos.destroy_all
  end
end
