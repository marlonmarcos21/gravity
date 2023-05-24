# == Schema Information
#
# Table name: chat_message_receipts
#
#  id              :bigint           not null, primary key
#  is_read         :boolean          default(FALSE)
#  receipt_type    :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  chat_group_id   :bigint
#  chat_message_id :bigint
#  user_id         :bigint
#
# Indexes
#
#  index_chat_message_receipts_on_chat_group_id    (chat_group_id)
#  index_chat_message_receipts_on_chat_message_id  (chat_message_id)
#  index_chat_message_receipts_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (chat_group_id => chat_groups.id)
#  fk_rails_...  (chat_message_id => chat_messages.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Chat::MessageReceipt, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
