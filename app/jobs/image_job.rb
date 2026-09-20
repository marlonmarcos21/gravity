class ImageJob < ApplicationJob
  queue_as :default

  def perform(image_ids, method)
    images = Image.where(id: image_ids)
    send(method, images)
  end

  private

  def process_styles(images)
    image = images.first
    object = BUCKET.object(image.key)
    # No acl.put here: the gateway answers PutObjectAcl with NotImplemented.
    # Objects are private by default and only reachable via presigned URLs.
    uri = URI(object.presigned_url(:get))
    file = uri.open
    image.source = file
    image.source_file_name = image.key.split('/').last
    image.save
    REDIS.srem(image.token, "image-#{image.id}")
    file.delete
  end

  def delete(images)
    images.destroy_all
  end
end
