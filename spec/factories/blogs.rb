FactoryBot.define do
  factory :blog do
    title { Faker::Lorem.paragraph(1) }
    body  { Faker::Lorem.paragraph(100) }
    user  { FactoryBot.create(:user) }
  end
end
