# == Schema Information
#
# Table name: users
#
#  id                         :integer          not null, primary key
#  active                     :boolean          default(TRUE)
#  current_sign_in_at         :datetime
#  current_sign_in_ip         :inet
#  email                      :string           default(""), not null
#  encrypted_password         :string           default(""), not null
#  first_name                 :string
#  last_name                  :string
#  last_sign_in_at            :datetime
#  last_sign_in_ip            :inet
#  profile_photo_content_type :string
#  profile_photo_file_name    :string
#  profile_photo_file_size    :integer
#  profile_photo_updated_at   :datetime
#  remember_created_at        :datetime
#  reset_password_sent_at     :datetime
#  reset_password_token       :string
#  sign_in_count              :integer          default(0), not null
#  slug                       :string
#  tsv_name                   :tsvector
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_tsv_name              (tsv_name) USING gin
#
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
