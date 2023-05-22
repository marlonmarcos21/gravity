# == Schema Information
#
# Table name: chat_message_attachments
#
#  id                  :bigint           not null, primary key
#  source_content_type :string
#  source_file_name    :string
#  source_file_size    :integer
#  source_updated_at   :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  chat_message_id     :bigint
#
# Indexes
#
#  index_chat_message_attachments_on_chat_message_id  (chat_message_id)
#
# Foreign Keys
#
#  fk_rails_...  (chat_message_id => chat_messages.id)
#

class Chat::MessageAttachment < ApplicationRecord
  ATTACHMENT_OPTIONS = {
    styles: {
      thumb: { geometry: '200x', processors: [:thumbnail] }
    },
    storage: :s3,
    s3_credentials: Rails.root.join('config/s3.yml'),
    s3_region: ENV['AWS_S3_REGION'],
    s3_protocol: :https,
    s3_permissions: :private,
    s3_url_options: { virtual_host: true }
  }.freeze

  ALLOWED_CONTENT_TYPE = %r{
    \A
    (
      application/
      (.*pdf|
        octet-stream|
        download|
        msword|
        vnd\.ms-(excel|powerpoint)|
        vnd\.openxmlformats-officedocument\.[\w\W]+
      )|
      image/.*|
      text/(plain|csv)
    )\Z
  }x

  include WithAttachment

  belongs_to :message, class_name: 'Chat::Message', foreign_key: :chat_message_id, inverse_of: :attachments
end
