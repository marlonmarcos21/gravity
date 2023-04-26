# == Schema Information
#
# Table name: chat_groups_users
#
#  id            :bigint           not null, primary key
#  is_read       :boolean          default(TRUE)
#  joined        :boolean          default(TRUE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  chat_group_id :bigint
#  user_id       :bigint
#
# Indexes
#
#  index_chat_groups_users_on_chat_group_id              (chat_group_id)
#  index_chat_groups_users_on_user_id                    (user_id)
#  index_chat_groups_users_on_user_id_and_chat_group_id  (user_id,chat_group_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (chat_group_id => chat_groups.id)
#  fk_rails_...  (user_id => users.id)
#
class Chat::GroupsUser < ApplicationRecord
  belongs_to :user
  belongs_to :chat_group, class_name: 'Chat::Group', inverse_of: :groups_users

  scope :joined, -> { where(joined: true) }
end
