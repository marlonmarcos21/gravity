class CreateChatGroupsUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :chat_groups_users do |t|
      t.references :user, foreign_key: true
      t.references :chat_group, foreign_key: true
      t.boolean    :is_read, default: true
      t.boolean    :joined,  default: true

      t.timestamps
    end

    add_index :chat_groups_users, [:user_id, :chat_group_id], unique: true
  end
end
