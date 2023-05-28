FactoryBot.define do
  factory :chat_message_attachment, class: 'Chat::MessageAttachment' do
    message { FactoryBot.create(:chat_message) }
  end
end
