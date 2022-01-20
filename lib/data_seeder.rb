module DataSeeder
  class << self
    def users
      password = '123123123'
      user1 = User.create(
        email: 'user1@example.com',
        first_name: 'First',
        last_name: 'User',
        password: password,
        password_confirmation: password
      )
      UserProfile.create(user: user1)

      user2 = User.create(
        email: 'user2@example.com',
        first_name: 'Second',
        last_name: 'User',
        password: password,
        password_confirmation: password
      )
      UserProfile.create(user: user2)
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
  end
end
