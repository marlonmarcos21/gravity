# == Schema Information
#
# Table name: blogs
#
#  id           :integer          not null, primary key
#  body         :text
#  published    :boolean          default(FALSE)
#  published_at :datetime
#  slug         :string
#  title        :string
#  tsv_name     :tsvector
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  category_id  :bigint
#  user_id      :integer
#
# Indexes
#
#  index_blogs_on_category_id  (category_id)
#  index_blogs_on_slug         (slug)
#  index_blogs_on_tsv_name     (tsv_name) USING gin
#  index_blogs_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#
require 'rails_helper'

RSpec.describe Blog, type: :model do
  describe 'Associations & Validations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to have_many :blog_media }
    it { is_expected.to have_many :likes }
  end
end
