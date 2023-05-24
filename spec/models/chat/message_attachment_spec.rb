# == Schema Information
#
# Table name: chat_message_attachments
#
#  id                  :bigint           not null, primary key
#  source_content_type :string
#  source_file_name    :string
#  source_file_size    :integer
#  source_updated_at   :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  chat_message_id     :bigint
#
# Indexes
#
#  index_chat_message_attachments_on_chat_message_id  (chat_message_id)
#
# Foreign Keys
#
#  fk_rails_...  (chat_message_id => chat_messages.id)
#
require 'rails_helper'

RSpec.describe Chat::MessageAttachment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
