# t.string     :title
# t.text       :body
# t.boolean    :published
# t.references :user

class Post < ActiveRecord::Base
  belongs_to :user

  validates :user, presence: true
end
