class AddCategoryToRecipe < ActiveRecord::Migration[6.1]
  def change
    add_reference :recipes,
                  :category,
                  index: true,
                  foreign_key: { to_table: :recipe_categories }

    add_column :recipes, :published_at, :datetime
  end
end
