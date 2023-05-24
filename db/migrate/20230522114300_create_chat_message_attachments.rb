class CreateChatMessageAttachments < ActiveRecord::Migration[6.1]
  def change
    create_table :chat_message_attachments do |t|
      t.string     :source_content_type
      t.string     :source_file_name
      t.integer    :source_file_size
      t.datetime   :source_updated_at

      t.references :chat_message, foreign_key: true

      t.timestamps
    end
  end
end
