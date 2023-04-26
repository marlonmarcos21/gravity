# == Schema Information
#
# Table name: friend_requests
#
#  id           :integer          not null, primary key
#  status       :string           default("pending")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  requester_id :integer
#  user_id      :integer
#
# Indexes
#
#  index_friend_requests_on_requester_id  (requester_id)
#  index_friend_requests_on_user_id       (user_id)
#

class FriendRequest < ApplicationRecord
  AVAILABLE_STATUSES = %w(pending canceled accepted rejected).freeze

  belongs_to :user
  belongs_to :requester, class_name: 'User'

  has_many :friends, dependent: :destroy

  validates :user,      presence: true
  validates :requester, presence: true
  validates :status,    presence: true, inclusion: { in: AVAILABLE_STATUSES }
  validates :user_id,   uniqueness: { scope: :requester_id }
end
