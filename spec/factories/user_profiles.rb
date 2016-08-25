FactoryGirl.define do
  factory :user_profile do
    user { FactoryGirl.create(:user) }
  end
end
