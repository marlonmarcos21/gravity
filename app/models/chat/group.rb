# == Schema Information
#
# Table name: chat_groups
#
#  id             :bigint           not null, primary key
#  chat_room_name :string
#  is_group_chat  :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Chat::Group < ApplicationRecord
  has_many :messages,         class_name: 'Chat::Message',        foreign_key: :chat_group_id
  has_many :message_receipts, class_name: 'Chat::MessageReceipt', foreign_key: :chat_group_id
  has_many :groups_users,     class_name: 'Chat::GroupsUser',     foreign_key: :chat_group_id
  has_many :users,            through: :groups_users

  has_many :participants,
           -> { where(chat_groups_users: { joined: true }) },
           through: :groups_users,
           source: :user

  has_many :unread_messages,
           -> { where(chat_message_receipts: { receipt_type: 'inbox', is_read: false }) },
           through: :message_receipts,
           source: :message

  scope :group_chat,     -> { where(is_group_chat: true) }
  scope :non_group_chat, -> { where(is_group_chat: false) }

  def self.between(user, other_user)
    return if user == other_user

    joins(:groups_users)
      .non_group_chat
      .where(chat_groups_users: { user_id: [user.id, other_user.id] })
      .group('chat_groups.id, chat_groups_users.chat_group_id')
      .having('count(chat_groups_users.chat_group_id) = 2')
      .first
  end
end
