# == Schema Information
#
# Table name: images
#
#  id                  :integer          not null, primary key
#  attachable_type     :string
#  height              :integer
#  key                 :string
#  main_image          :boolean          default(FALSE)
#  source_content_type :string
#  source_file_name    :string
#  source_file_size    :integer
#  source_updated_at   :datetime
#  token               :string
#  width               :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  attachable_id       :integer
#
# Indexes
#
#  index_images_on_attachable_type_and_attachable_id  (attachable_type,attachable_id)
#

class Image < ApplicationRecord
  ATTACHMENT_OPTIONS = {
    styles: {
      thumb: { geometry: '150x', processors: [:thumbnail] },
      main: { geometry: '1024x', processors: [:thumbnail] }
    },
    storage: :s3,
    s3_credentials: Rails.root.join('config/s3.yml'),
    s3_region: ENV['AWS_S3_REGION'],
    s3_protocol: :https,
    s3_permissions: :private,
    s3_url_options: { virtual_host: true }
  }.freeze

  ALLOWED_CONTENT_TYPE = %r{\Aimage/(\w?jpeg|jpg|png|gif|webp)\Z}

  include WithAttachment

  before_post_process :skip_gif

  after_post_process :save_image_dimensions

  after_destroy :delete_uploaded_file

  after_commit :enqueue_process_styles, on: :create

  scope :gif, -> { where(source_content_type: 'image/gif') }
  scope :non_gif, -> { where.not(source_content_type: 'image/gif') }

  def render_style
    small_image? ? :original : :main
  end

  def small_image?
    width < 1024
  end

  def gif?
    source_content_type == 'image/gif'
  end

  private

  def save_image_dimensions
    return if gif?

    main_geometry = Paperclip::Geometry.from_file(source.queued_for_write[:main])
    orig_geometry = Paperclip::Geometry.from_file(source.queued_for_write[:original])

    if main_geometry.width > orig_geometry.width
      self.width  = orig_geometry.width
      self.height = orig_geometry.height
    else
      self.width  = main_geometry.width
      self.height = main_geometry.height
    end
  end

  def enqueue_process_styles
    return unless source.blank?

    REDIS.sadd(token, "image-#{id}")
    ImageJob.perform_later(id, 'process_styles')
  end

  def delete_uploaded_file
    return unless key

    object = BUCKET.object(key)
    object.delete
  end

  def skip_gif
    !gif?
  end
end
