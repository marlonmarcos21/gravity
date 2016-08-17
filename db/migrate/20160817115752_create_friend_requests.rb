class CreateFriendRequests < ActiveRecord::Migration
  def change
    create_table :friend_requests do |t|
      t.references :user,      index: true
      t.references :requester, index: true
      t.string     :status,    default: 'pending'

      t.timestamps null: false
    end
  end
end
