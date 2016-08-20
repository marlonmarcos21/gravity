# t.attachment :source
# t.references :attachable, polymorphic: true
# t.string     :token
# t.integer    :width
# t.integer    :height

class BlogMedium < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true

  has_attached_file :source, styles: { thumb: { geometry: '150x', processors: [:thumbnail] } },
                             storage: :s3,
                             s3_credentials: "#{Rails.root}/config/s3.yml",
                             s3_region: ENV['AWS_S3_REGION'],
                             s3_protocol: :https

  validates_attachment_presence :source
  validates_attachment_content_type :source, content_type: /\Aimage\/(\w?jpeg|jpg|png|gif)\Z/
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
