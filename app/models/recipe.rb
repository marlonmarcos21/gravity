class Recipe < ApplicationRecord
  has_rich_text :ingredients
  has_rich_text :instructions
end
