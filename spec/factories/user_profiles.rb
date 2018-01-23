FactoryBot.define do
  factory :user_profile do
    user { FactoryBot.create(:user) }
  end
end
