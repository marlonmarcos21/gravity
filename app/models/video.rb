# == Schema Information
#
# Table name: videos
#
#  id              :integer          not null, primary key
#  attachable_type :string
#  key             :string
#  source_meta     :json
#  token           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  attachable_id   :integer
#
# Indexes
#
#  index_videos_on_attachable_type_and_attachable_id  (attachable_type,attachable_id)
#

class Video < ApplicationRecord
  belongs_to :attachable, polymorphic: true, optional: true

  validates :token, presence: true

  after_destroy :delete_uploaded_file

  after_commit :enqueue_process_metadata, on: :create

  def source_url
    S3.presigned_url(key)
  end

  def screenshot_url
    return if source_meta.blank?

    S3.presigned_url(source_meta['screenshot_key'])
  end

  def aspect_ratio_display
    return if source_meta.blank?

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

  def enqueue_process_metadata
    REDIS.sadd(token, "video-#{id}")
    VideoJob.perform_later(id, 'process_metadata')
  end

  def delete_uploaded_file
    return unless key

    object = BUCKET.object(key)
    object.delete
  end
end
