# t.references :user
# t.references :friend
# t.references :friend_request

class Friend < ApplicationRecord
  belongs_to :friend_request
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  validates :friend_request, presence: true
  validates :user,           presence: true
  validates :friend,         presence: true

  validates :user_id, uniqueness: { scope: :friend_id }
end
