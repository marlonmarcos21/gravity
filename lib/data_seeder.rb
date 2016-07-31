module DataSeeder
  class << self
    def posts(count = 50)
      count.times do
        Post.create(
          title: Faker::Lorem.sentences(1),
          body: Faker::Lorem.paragraph(5),
          published: true,
          user_id: 2
        )
      end
    end
  end
end
