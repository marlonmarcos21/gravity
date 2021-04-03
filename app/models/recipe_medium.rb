# t.text   file_data
# t.jsonb  video_meta
# t.string s3_id

class RecipeMedium < ApplicationRecord
  include ImageUploader[:file]

  belongs_to :user

  before_save :set_s3_id, if: :file_data_changed?

  after_commit :enqueue_process_metadata, on: :create

  def screenshot_url
    return if video_meta.blank?

    object = BUCKET.object(video_meta['screenshot_key'])
    get_s3_url(object)
  end

  def file_metadata
    JSON.parse(file_data)
  end

  def aspect_ratio_display
    return if video_meta.blank?

    orig_width = width = video_meta['width']
    orig_height = height = video_meta['height']
    aspect = video_meta['aspect']

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

  def set_s3_id
    self.s3_id = file_metadata['id'].split('.')[0]
  end

  def enqueue_process_metadata
    file_metadata = JSON.parse(file_data)
    mime_type = file_metadata['metadata']['mime_type']
    return unless mime_type.starts_with?('video')

    RecipeMediumVideoJob.perform_later(id, 'process_metadata')
  end

  def get_s3_url(object)
    uri = URI(object.public_url(virtual_host: true))
    uri.port = nil
    uri.scheme = 'https'
    uri.to_s
  end
end
