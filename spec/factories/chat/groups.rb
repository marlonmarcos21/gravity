FactoryBot.define do
  factory :chat_group, class: 'Chat::Group' do
    participants { FactoryBot.create_list(:user, 2) }
  end
end
