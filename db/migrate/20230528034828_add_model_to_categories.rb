class AddModelToCategories < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :model, :string
    add_index :categories, :model
  end
end
