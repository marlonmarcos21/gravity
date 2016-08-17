# t.attachment :source
# t.json       :source_meta
# t.references :attachable, polymorphic: true
# t.string     :token

class Video < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true

  has_attached_file :source, styles: { thumb: { geometry: '150x100!', format: 'jpg', time: 10 }}, processors: [:transcoder],
                             storage: :s3,
                             s3_credentials: "#{Rails.root}/config/s3.yml",
                             s3_region: ENV['AWS_S3_REGION'],
                             s3_protocol: :https,
                             s3_permissions: :private

  validates_attachment_presence :source
  validates_attachment_content_type :source, content_type: /\Avideo\/mp4\Z/
  validates :token, presence: true

  # Instance methods

  def aspect_ratio_display
    orig_width = width = source_meta['width']
    orig_height = height = source_meta['height']
    aspect = source_meta['aspect']
    aspect_ratio = "#{width}x#{height}"

    if orig_width > orig_height
      if orig_width > 516
        width = 516
        height = (516/aspect).round
      end
    else
      if orig_width > 258
        width = 270
        height = (270/aspect).round
      end
    end

    "#{width}x#{height}"
  end
end
