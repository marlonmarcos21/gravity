require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'Associations & Validations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :trackable }
  end
end
