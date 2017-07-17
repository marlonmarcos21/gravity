class AddPrivateFlagToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :private, :boolean, default: false
  end
end
