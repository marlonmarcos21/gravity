class CreateChatMessageReceipts < ActiveRecord::Migration[6.1]
  def change
    create_table :chat_message_receipts do |t|
      t.references :user,         foreign_key: true
      t.references :chat_group,   foreign_key: true
      t.references :chat_message, foreign_key: true
      t.boolean    :is_read, default: false
      t.string     :receipt_type

      t.timestamps
    end
  end
end
