class CreateChatGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :chat_groups do |t|
      t.string  :chat_room_name
      t.boolean :is_group_chat, default: false

      t.timestamps
    end
  end
end
