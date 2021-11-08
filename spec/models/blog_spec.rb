require 'rails_helper'

RSpec.describe Blog, type: :model do
  describe 'Associations & Validations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to have_many :blog_media }
    it { is_expected.to have_many :likes }
  end
end
