class RenamePrivateToPublicForPosts < ActiveRecord::Migration[6.0]
  def change
    rename_column :posts, :private, :public
    add_index :posts, :public
  end
end
