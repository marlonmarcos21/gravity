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
                    **S3::PUBLIC_PAPERCLIP_OPTIONS,
                    styles: { thumb: { geometry: '150x', processors: [:thumbnail] } }

  validates_attachment_presence :source
  validates_attachment_content_type :source, content_type: %r{\Aimage/(\w?jpeg|jpg|png|gif)\Z}
  validates :token, presence: true

  after_post_process :save_image_dimensions

  # Lives in the public bucket, so this is a plain, non-expiring URL. That
  # matters: TinyMCE writes it into the stored blog body, where a presigned URL
  # would stop working once the signature lapsed.
  def source_url(style = :original)
    source.url(style)
  end

  private

  def save_image_dimensions
    geometry    = Paperclip::Geometry.from_file(source.queued_for_write[:original])
    self.width  = geometry.width
    self.height = geometry.height
  end
end
