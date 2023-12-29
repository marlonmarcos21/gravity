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
  self.inheritance_column = :model

  enum model: { Blog: 'Blog', Recipe: 'Recipe' }

  extend FriendlyId::FinderMethods
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  validates :title, presence: true

  class << self
    def find_sti_class(type_name)
      "Category::#{type_name}".constantize
    end

    def sti_name
      name.demodulize
    end
  end

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end
end
