# t.references :user, index: true
# t.references :trackable, polymorphic: true, index: true

class Like < ApplicationRecord
  belongs_to :user
  belongs_to :trackable, polymorphic: true
end
