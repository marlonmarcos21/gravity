class AddVideoMetaToRecipeMedia < ActiveRecord::Migration[6.1]
  def change
    add_column :recipe_media, :video_meta, :jsonb, default: {}
  end
end
