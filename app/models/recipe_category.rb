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

class RecipeCategory < ApplicationRecord
  has_many :recipes,
           foreign_key: :category_id,
           inverse_of: :category,
           dependent: :restrict_with_error

  extend FriendlyId::FinderMethods
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  validates :title, presence: true

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end
end
