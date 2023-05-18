# == Schema Information
#
# Table name: chat_message_receipts
#
#  id              :bigint           not null, primary key
#  is_read         :boolean          default(FALSE)
#  receipt_type    :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  chat_group_id   :bigint
#  chat_message_id :bigint
#  user_id         :bigint
#
# Indexes
#
#  index_chat_message_receipts_on_chat_group_id    (chat_group_id)
#  index_chat_message_receipts_on_chat_message_id  (chat_message_id)
#  index_chat_message_receipts_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (chat_group_id => chat_groups.id)
#  fk_rails_...  (chat_message_id => chat_messages.id)
#  fk_rails_...  (user_id => users.id)
#

class Chat::MessageReceipt < ApplicationRecord
  enum receipt_type: { inbox: 'inbox', outbox: 'outbox' }

  belongs_to :user
  belongs_to :message, class_name: 'Chat::Message', foreign_key: :chat_message_id, inverse_of: :receipts
  belongs_to :group,   class_name: 'Chat::Group',   foreign_key: :chat_group_id, inverse_of: :message_receipts
end
