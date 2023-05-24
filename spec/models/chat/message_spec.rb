# == Schema Information
#
# Table name: chat_messages
#
#  id            :bigint           not null, primary key
#  body          :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  chat_group_id :bigint
#  sender_id     :bigint
#
# Indexes
#
#  index_chat_messages_on_chat_group_id  (chat_group_id)
#  index_chat_messages_on_sender_id      (sender_id)
#
# Foreign Keys
#
#  fk_rails_...  (chat_group_id => chat_groups.id)
#  fk_rails_...  (sender_id => users.id)
#
require 'rails_helper'

RSpec.describe Chat::Message, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
