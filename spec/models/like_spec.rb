# == Schema Information
#
# Table name: likes
#
#  id             :bigint           not null, primary key
#  trackable_type :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  trackable_id   :bigint
#  user_id        :bigint
#
# Indexes
#
#  index_likes_on_trackable_type_and_trackable_id  (trackable_type,trackable_id)
#  index_likes_on_user_id                          (user_id)
#
require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'Associations & Validations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :trackable }
  end
end
