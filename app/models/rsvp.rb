# == Schema Information
#
# Table name: rsvps
#
#  id         :bigint           not null, primary key
#  email      :string
#  name       :string           not null
#  notes      :text
#  phone      :string
#  status     :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :bigint           not null
#  parent_id  :bigint
#
# Indexes
#
#  index_rsvps_on_event_id   (event_id)
#  index_rsvps_on_parent_id  (parent_id)
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#

class Rsvp < ApplicationRecord
  belongs_to :event
  belongs_to :parent, class_name: 'Rsvp', optional: true

  has_many :children, class_name: 'Rsvp', foreign_key: :parent_id, dependent: :destroy, inverse_of: :parent

  enum status: {
    accepted: 'accepted',
    declined: 'declined'
  }
end
