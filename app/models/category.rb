# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  model      :string
#  slug       :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_categories_on_model  (model)
#  index_categories_on_title  (title) UNIQUE
#

class Category < ApplicationRecord
  enum model: { Blog: 'Blog', Recipe: 'Recipe' }

  has_many :blogs,   inverse_of: :category, dependent: :restrict_with_error
  has_many :recipes, inverse_of: :category, dependent: :restrict_with_error

  extend FriendlyId::FinderMethods
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  validates :title, presence: true

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end
end
