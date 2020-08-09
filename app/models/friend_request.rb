# t.references :user
# t.references :requester
# t.string     :status

class FriendRequest < ApplicationRecord
  AVAILABLE_STATUSES = %w(pending canceled accepted rejected).freeze

  belongs_to :user
  belongs_to :requester, class_name: 'User', foreign_key: :requester_id

  has_many :friends

  validates :user,      presence: true
  validates :requester, presence: true
  validates :status,    presence: true, inclusion: { in: AVAILABLE_STATUSES }
  validates :user_id,   uniqueness: { scope: :requester_id }
end
