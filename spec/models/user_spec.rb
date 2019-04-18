require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Associations & Validations' do
    it { is_expected.to have_many :posts }
    it { is_expected.to have_many :blogs }
    it { is_expected.to have_many :likes }
    it { is_expected.to have_many :friends }
    it { is_expected.to have_many :friend_requests }
    it { is_expected.to have_many :requested_friends }
    it { is_expected.to validate_presence_of :first_name }
    it { is_expected.to validate_presence_of :last_name }
  end
end
