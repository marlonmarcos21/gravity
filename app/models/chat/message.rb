# == Schema Information
#
# Table name: chat_messages
#
#  id            :bigint           not null, primary key
#  body          :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  chat_group_id :bigint
#  sender_id     :bigint
#
# Indexes
#
#  index_chat_messages_on_chat_group_id  (chat_group_id)
#  index_chat_messages_on_sender_id      (sender_id)
#
# Foreign Keys
#
#  fk_rails_...  (chat_group_id => chat_groups.id)
#  fk_rails_...  (sender_id => users.id)
#

class Chat::Message < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :group,
             class_name: 'Chat::Group',
             foreign_key: :chat_group_id,
             inverse_of: :messages,
             touch: true

  has_many :receipts,
           class_name: 'Chat::MessageReceipt',
           foreign_key: :chat_message_id,
           inverse_of: :message,
           dependent: :destroy

  has_many :attachments,
           class_name: 'Chat::MessageAttachment',
           foreign_key: :chat_message_id,
           inverse_of: :message,
           dependent: :destroy

  def as_json(opts = {})
    super(opts).merge(
      'avatar_source' => sender.profile_photo_url(:thumb),
      'sent_date'     => created_at.to_date,
      'sent_time'     => created_at.strftime('%H:%M'),
      'attachment'    => attachments.map(&:source_url).first  # TODO: support multiple attachments
    )
  end
end
