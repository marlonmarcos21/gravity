class VideoJob < ApplicationJob
  queue_as :default

  def perform(video_ids, method)
    videos = Video.where(id: video_ids)
    send(method, videos)
  end

  private

  def process_metadata(videos)
    video     = videos.first
    object    = BUCKET.object(video.key)
    file      = URI(object.presigned_url(:get)).open
    movie     = FFMPEG::Movie.new(file.path)
    key_parts = video.key.split('/')
    filename  = key_parts.pop.sub(/\.\S*$/, '.jpg')
    s3_key    = "#{key_parts.join('/')}/#{filename}"

    screenshot_obj      = BUCKET.object(s3_key)
    duration            = movie.duration.to_i
    seek_time           = duration > 9 ? 5 : duration / 2
    screenshot_filepath = Tempfile.create(filename)
    screenshot          = movie.screenshot(screenshot_filepath.path, seek_time: seek_time)
    screenshot_file     = File.open(screenshot.path)

    screenshot_obj.upload_file(screenshot_file)

    video.source_meta = {
      width:  movie.width,
      height: movie.height,
      aspect: movie.width / movie.height.to_f,
      screenshot_key: screenshot_obj.key
    }
    video.save

    REDIS.srem(video.token, "video-#{video.id}")
    file.delete
    File.delete(screenshot_file)
  end

  def delete(videos)
    videos.destroy_all
  end
end
