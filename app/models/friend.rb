# == Schema Information
#
# Table name: friends
#
#  id                :integer          not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  friend_id         :integer
#  friend_request_id :integer
#  user_id           :integer
#
# Indexes
#
#  index_friends_on_friend_id          (friend_id)
#  index_friends_on_friend_request_id  (friend_request_id)
#  index_friends_on_user_id            (user_id)
#

class Friend < ApplicationRecord
  belongs_to :friend_request
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  validates :friend_request, presence: true
  validates :user,           presence: true
  validates :friend,         presence: true

  validates :user_id, uniqueness: { scope: :friend_id }
end
