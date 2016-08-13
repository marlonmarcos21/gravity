class RemoveTitleFromPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :title, :string
  end
end
