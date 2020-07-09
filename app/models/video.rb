# t.attachment :source
# t.json       :source_meta
# t.references :attachable, polymorphic: true
# t.string     :token

class Video < ApplicationRecord
  ATTACHMENT_OPTIONS = {
    styles: { geometry: '150x100!', format: 'jpg', time: 10 },
    processors: [:transcoder],
    storage: :s3,
    s3_credentials: "#{Rails.root}/config/s3.yml",
    s3_region: ENV['AWS_S3_REGION'],
    s3_protocol: :https,
    s3_permissions: :private,
    s3_url_options: { virtual_host: true }
  }

  ALLOWED_CONTENT_TYPE = %r{\Avideo\/(mp4|quicktime|x-msvideo)\Z}

  include WithAttachment

  after_commit :enqueue_process_styles, on: :create

  def aspect_ratio_display
    orig_width = width = source_meta['width']
    orig_height = height = source_meta['height']
    aspect = source_meta['aspect']

    if orig_width > orig_height && orig_width > 516
      width = 516
      height = (516 / aspect).round
    elsif orig_height > orig_width && orig_width > 270
      width = 270
      height = (270 / aspect).round
    end

    "#{width}x#{height}"
  end

  private

  def enqueue_process_styles
    return unless source.blank?

    REDIS.sadd(token, "video-#{id}")
    VideoJob.perform_later(id, 'process_styles')
  end
end
