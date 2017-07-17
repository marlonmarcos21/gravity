# t.references :user
# t.references :friend
# t.references :friend_request

class Friend < ActiveRecord::Base
  belongs_to :friend_request
  belongs_to :user
  belongs_to :friend, class_name: 'User', foreign_key: :friend_id

  validates :friend_request, presence: true
  validates :user,           presence: true
  validates :friend,         presence: true

  validates :user_id, uniqueness: { scope: :friend_id }
end
