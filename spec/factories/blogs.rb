FactoryBot.define do
  factory :blog do
    title { Faker::Lorem.sentence }
    body  { Faker::Lorem.paragraphs(number: 20).join }
    user  { FactoryBot.create(:user) }
  end
end
