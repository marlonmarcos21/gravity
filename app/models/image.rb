# t.attachment :source
# t.references :attachable, polymorphic: true
# t.boolean    :main_image, default: false
# t.string     :token
# t.integer    :width
# t.integer    :height

class Image < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true

  has_attached_file :source, styles: { thumb: { geometry: '150x', processors: [:thumbnail] },
                                       main: { geometry: '800x', processors: [:thumbnail] },
                                       portrait: { geometry: 'x500', processors: [:thumbnail] } },
                             storage: :s3,
                             s3_credentials: "#{Rails.root}/config/s3.yml",
                             s3_region: ENV['AWS_S3_REGION'],
                             s3_protocol: :https,
                             s3_permissions: :private,
                             s3_url_options: { virtual_host: true }

  validates_attachment_presence :source
  validates_attachment_content_type :source, content_type: %r{\Aimage/(\w?jpeg|jpg|png|gif)\Z}
  validates :token, presence: true

  before_post_process :skip_gif

  after_post_process :save_image_dimensions

  def source_url(style = :original, expires_in = 3600)
    presigned_url = source.expiring_url(expires_in.to_i, style)
    uri = URI presigned_url
    uri.port = nil
    uri.scheme = 'https'
    uri.to_s
  end

  def gif?
    source_content_type == 'image/gif'
  end

  private

  def save_image_dimensions
    return if gif?
    geometry    = Paperclip::Geometry.from_file(source.queued_for_write[:main])
    self.width  = geometry.width
    self.height = geometry.height
  end

  def skip_gif
    !gif?
  end
end
