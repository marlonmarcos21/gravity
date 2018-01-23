FactoryBot.define do
  factory :post do
    body { Faker::Lorem.paragraph }
    user { FactoryBot.create(:user) }
  end
end
