module WithAttachment
  extend ActiveSupport::Concern

  included do
    belongs_to :attachable, polymorphic: true, optional: true

    has_attached_file :source, const_get(:ATTACHMENT_OPTIONS)

    validates_attachment_content_type :source, content_type: const_get(:ALLOWED_CONTENT_TYPE)
  end

  def source_url(style: :original, expires_in: 3_600)
    presigned_url = source.expiring_url(expires_in.to_i, style)
    uri = URI presigned_url
    uri.port = nil
    uri.scheme = 'https'
    uri.to_s
  end
end
