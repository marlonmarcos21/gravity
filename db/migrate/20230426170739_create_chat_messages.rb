class CreateChatMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :chat_messages do |t|
      t.references :chat_group, foreign_key: true
      t.bigint     :sender_id, index: true
      t.text       :body

      t.timestamps
    end

    add_foreign_key :chat_messages, :users, column: :sender_id
  end
end
