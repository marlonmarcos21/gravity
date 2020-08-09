FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.sentence }
    commentable { FactoryBot.create(:post) }
    user { FactoryBot.create(:user) }
  end
end
