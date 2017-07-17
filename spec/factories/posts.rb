FactoryGirl.define do
  factory :post do
    body { Faker::Lorem.paragraph }
    user { FactoryGirl.create(:user) }
  end
end
