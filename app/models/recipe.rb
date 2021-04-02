class Recipe < ApplicationRecord
  belongs_to :user

  has_rich_text :ingredients
  has_rich_text :instructions
end
