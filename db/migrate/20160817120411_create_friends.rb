class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.references :user,           index: true
      t.references :friend,         index: true
      t.references :friend_request, index: true

      t.timestamps null: false
    end
  end
end
