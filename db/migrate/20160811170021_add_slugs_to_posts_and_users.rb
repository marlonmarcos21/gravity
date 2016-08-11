class AddSlugsToPostsAndUsers < ActiveRecord::Migration
  def change
    add_column :posts, :slug, :string, index: true
    add_column :users, :slug, :string, index: true
    add_index  :blogs, :slug
  end
end
