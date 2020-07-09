class ImageJob < ApplicationJob
  queue_as :default

  def perform(image_id, method)
    image = Image.find image_id
    send(method, image)
  end

  private

  def bucket
    @bucket ||= Aws::S3::Resource.new.bucket(ENV['AWS_S3_BUCKET'])
  end

  def process_styles(image)
    object = bucket.object(image.key)
    uri = URI(object.presigned_url(:get))
    file = uri.open
    image.source = file
    image.source_file_name = image.key.split('/').last
    image.save
    REDIS.srem(image.token, "post-#{image.id}")
    file.delete
  end
end
