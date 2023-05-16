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
  belongs_to :group,  class_name: 'Chat::Group', foreign_key: :chat_group_id, touch: true

  has_many :receipts, class_name: 'Chat::MessageReceipt', foreign_key: :chat_message_id
end
