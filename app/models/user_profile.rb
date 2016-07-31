# t.string     :first_name
# t.string     :last_name
# t.date       :date_of_birth
# t.string     :street_address1
# t.string     :street_address2
# t.string     :city
# t.string     :state
# t.string     :country
# t.string     :postal_code
# t.string     :phone_number
# t.string     :mobile_number
# t.references :user

class UserProfile < ActiveRecord::Base
  belongs_to :user

  validates :user, presence: true
end
