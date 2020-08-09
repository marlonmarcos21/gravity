class AddKeyToVideos < ActiveRecord::Migration[6.0]
  def change
    add_column :videos, :key, :string, index: true
  end
end
