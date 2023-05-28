FactoryBot.define do
  factory :chat_message, class: 'Chat::Message' do
    transient do
      groups { {} }
    end

    before :create do |message, evaluator|
      message.group ||= FactoryBot.create(:chat_group)
      sender     = evaluator.groups[:sender] || message.group.participants.first
      recipients = evaluator.groups[:recipient] ||
                     evaluator.groups[:recipients] ||
                     message.group.participants.last

      receipts = []
      receipts << FactoryBot.build(
        :chat_message_receipt,
        message: message,
        user: sender,
        group: message.group,
        is_read: true,
        receipt_type: 'outbox'
      )

      Array(recipients).each do |r|
        receipts << FactoryBot.build(
          :chat_message_receipt,
          message: message,
          user: r,
          group: message.group,
          receipt_type: 'inbox'
        )
      end

      message.receipts = receipts
      message.sender = sender
    end

    body { Faker::Lorem.sentence }
  end
end
