class AddSlugToRecipeCategories < ActiveRecord::Migration[6.1]
  def change
    add_column :recipe_categories, :slug, :string, index: true
  end
end
