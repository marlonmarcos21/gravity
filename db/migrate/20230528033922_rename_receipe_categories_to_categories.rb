class RenameReceipeCategoriesToCategories < ActiveRecord::Migration[6.1]
  def change
    rename_table :recipe_categories, :categories
  end
end
