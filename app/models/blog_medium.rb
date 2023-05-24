# == Schema Information
#
# Table name: blog_media
#
#  id                  :integer          not null, primary key
#  attachable_type     :string
#  height              :integer
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
#  index_blog_media_on_attachable_type_and_attachable_id  (attachable_type,attachable_id)
#

class BlogMedium < ApplicationRecord
  belongs_to :attachable, polymorphic: true, optional: true

  has_attached_file :source,
                    styles: { thumb: { geometry: '150x', processors: [:thumbnail] } },
                    storage: :s3,
                    s3_credentials: Rails.root.join('config/s3.yml'),
                    s3_region: ENV['AWS_S3_REGION'],
                    s3_protocol: :https

  validates_attachment_presence :source
  validates_attachment_content_type :source, content_type: %r{\Aimage/(\w?jpeg|jpg|png|gif)\Z}
  validates :token, presence: true

  after_post_process :save_image_dimensions

  def source_url(style = :original)
    source.url(style).sub("#{ENV['AWS_S3_HOST_NAME']}/", '')
  end

  private

  def save_image_dimensions
    geometry    = Paperclip::Geometry.from_file(source.queued_for_write[:original])
    self.width  = geometry.width
    self.height = geometry.height
  end
end
