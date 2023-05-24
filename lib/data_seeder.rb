module DataSeeder
  class << self
    def users(count = 50)
      password = '123123123'
      user = User.create(
        email: 'user1@example.com',
        first_name: 'First',
        last_name: 'User',
        password: password,
        password_confirmation: password
      )
      UserProfile.create(user: user)

      count.times do
        user = User.create(
          email: Faker::Internet.email,
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          password: password,
          password_confirmation: password
        )
        UserProfile.create(user: user)
      end
    end

    def posts(count = 50)
      count.times do
        Post.create(
          body: Faker::Lorem.paragraph(sentence_count: 4),
          published: true,
          user_id: 2
        )
      end
    end

    def messages(chat_group_id, count = 50)
      chat_group = Chat::Group.find(chat_group_id)
      participants = chat_group.participants
      total = 0

      until total >= 50
        sender = participants.sample
        rand(1..3).times do
          msg = chat_group.messages.build(
            sender: sender,
            body: Faker::Lorem.sentences.join(' ')
          )

          msg.receipts.build(
            chat_group_id: chat_group.id,
            receipt_type: 'outbox',
            user: sender,
            message: msg
          )

          msg.receipts.build(
            chat_group_id: chat_group.id,
            receipt_type: 'inbox',
            user: (participants - [sender]).first,
            message: msg
          )

          msg.save!
          total += 1
        end
      end
    end
  end
end
