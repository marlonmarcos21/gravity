class VideoJob < ApplicationJob
  queue_as :default

  def perform(video_ids, method)
    videos = Video.where(id: video_ids)
    send(method, videos)
  end

  private

  def bucket
    @bucket ||= Aws::S3::Resource.new.bucket(ENV['AWS_S3_BUCKET'])
  end

  def process_styles(videos)
    video = videos.first
    object = bucket.object(video.key)
    uri = URI(object.presigned_url(:get))
    file = uri.open
    video.source = file
    video.source_file_name = video.key.split('/').last
    video.save
    REDIS.srem(video.token, "video-#{video.id}")
    file.delete
  end

  def delete(videos)
    videos.destroy_all
  end
end
