# t.string :name
# t.string :email
# t.string :phone
# t.text   :notes
# t.string :status

class Rsvp < ApplicationRecord
  belongs_to :event
  belongs_to :parent, class_name: 'Rsvp', optional: true

  has_many :children, class_name: 'Rsvp', foreign_key: :parent_id

  enum status: {
    accepted: 'accepted',
    declined: 'declined'
  }
end
