class MakePostPublishedByDefault < ActiveRecord::Migration
  def change
    change_column_default :posts, :published, true
  end
end
