class ChangeDefaultPublishedStatusForPostsAndBlogs < ActiveRecord::Migration
  def change
    change_column_default :posts, :published, false
    change_column_default :blogs, :published, false
  end
end
