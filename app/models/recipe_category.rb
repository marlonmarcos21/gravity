# t.string :title, unique: true
# t.string :slug

class RecipeCategory < ApplicationRecord
  has_many :recipes, foreign_key: :category_id

  extend FriendlyId::FinderMethods
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  validates :title, presence: true

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end
end
