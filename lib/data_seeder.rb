module DataSeeder
  class << self
    def posts(count = 50)
      count.times do
        Post.create(
          body: Faker::Lorem.paragraph(4),
          published: true,
          user_id: 2
        )
      end
    end
  end
end
