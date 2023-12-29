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

class Category::Recipe < Category
  has_many :recipes,
           class_name: '::Recipe',
           inverse_of: :category,
           dependent: :restrict_with_error,
           foreign_key: :category_id
end
