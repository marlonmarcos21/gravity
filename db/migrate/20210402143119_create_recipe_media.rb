class CreateRecipeMedia < ActiveRecord::Migration[6.1]
  def change
    create_table :recipe_media do |t|
      t.text :file_data
      t.timestamps
    end
  end
end
