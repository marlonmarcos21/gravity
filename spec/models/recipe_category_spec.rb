# == Schema Information
#
# Table name: recipe_categories
#
#  id         :bigint           not null, primary key
#  slug       :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_recipe_categories_on_title  (title) UNIQUE
#
require 'rails_helper'

RSpec.describe RecipeCategory, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
