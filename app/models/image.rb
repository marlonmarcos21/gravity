# t.attachment :source
# t.references :attachable, polymorphic: true
# t.boolean    :main_image, default: false
# t.string     :token

class Image < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true

  has_attached_file :source, styles: { thumb:  { geometry: '150x150#',   processors: [:thumbnail] } },
                             storage: :s3,
                             s3_credentials: "#{Rails.root}/config/s3.yml",
                             s3_region: ENV['AWS_S3_REGION'],
                             s3_protocol: :https

  validates_attachment_presence :source
  validates_attachment_content_type :source, content_type: /\Aimage\/.*\Z/
end
