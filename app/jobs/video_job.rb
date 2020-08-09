class VideoJob < ApplicationJob
  queue_as :default

  def perform(video_ids, method)
    videos = Video.where(id: video_ids)
    send(method, videos)
  end

  private

  def process_metadata(videos)
    video = videos.first
    object = BUCKET.object(video.key)
    uri = URI(object.presigned_url(:get))
    file = uri.open
    movie = FFMPEG::Movie.new(file.path)
    filename = video.key.split('/').last
    screenshot_obj = BUCKET.object("uploads/#{SecureRandom.uuid}/#{filename}")
    screenshot_filepath = Rails.root.join('tmp', filename)
    screenshot = movie.screenshot(screenshot_filepath.to_s, seek_time: 5)
    screenshot_file = File.open(screenshot.path)
    screenshot_obj.upload_file(screenshot_file)
    metadata = {
      width: movie.width,
      height: movie.height,
      aspect: movie.width / movie.height.to_f,
      screenshot_key: screenshot_obj.key,
    }
    video.source_meta = metadata
    video.save
    REDIS.srem(video.token, "video-#{video.id}")
    file.delete
    File.delete(screenshot_file)
  end

  def delete(videos)
    videos.destroy_all
  end
end
