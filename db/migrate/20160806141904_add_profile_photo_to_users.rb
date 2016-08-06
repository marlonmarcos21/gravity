class AddProfilePhotoToUsers < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.attachment :profile_photo
    end
  end

  def down
    remove_attachment :users, :profile_photo
  end
end
