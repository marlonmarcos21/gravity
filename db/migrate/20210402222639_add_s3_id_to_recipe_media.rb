class AddS3IdToRecipeMedia < ActiveRecord::Migration[6.1]
  def change
    add_column :recipe_media, :s3_id, :string, index: true
  end
end
