FactoryBot.define do
  factory :chat_message_receipt, class: 'Chat::MessageReceipt' do
    message      { FactoryBot.create(:chat_message) }
    group        { message.group }
    user         { message.sender }
    receipt_type { 'inbox' }
    is_read      { true }
  end
end
