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
    s3_permissions: :private
  }.merge(S3::PAPERCLIP_OPTIONS).freeze

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
