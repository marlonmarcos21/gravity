# == Schema Information
#
# Table name: recipes
#
#  id           :bigint           not null, primary key
#  published    :boolean          default(FALSE)
#  published_at :datetime
#  slug         :string
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  category_id  :bigint
#  user_id      :bigint
#
# Indexes
#
#  index_recipes_on_category_id  (category_id)
#  index_recipes_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => recipe_categories.id)
#
require 'rails_helper'

RSpec.describe Recipe, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
