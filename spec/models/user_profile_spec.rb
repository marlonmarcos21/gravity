# == Schema Information
#
# Table name: user_profiles
#
#  id              :integer          not null, primary key
#  city            :string
#  country         :string
#  date_of_birth   :date
#  mobile_number   :string
#  phone_number    :string
#  postal_code     :string
#  state           :string
#  street_address1 :string
#  street_address2 :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_id         :integer
#
# Indexes
#
#  index_user_profiles_on_user_id  (user_id)
#
require 'rails_helper'

RSpec.describe UserProfile, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
