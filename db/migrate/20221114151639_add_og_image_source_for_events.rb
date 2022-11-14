class AddOgImageSourceForEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :og_image_source, :text
  end
end
