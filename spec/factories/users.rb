FactoryGirl.define do
  sequence :email do |n|
    n.to_s + Faker::Internet.email
  end

  factory :user do
    email
    first_name 'Stan'
    last_name  'Smith'
    password   '123123123'
    password_confirmation '123123123'

    factory :user_with_profile do
      after :create do |user|
        FactoryGirl.create(:user_profile, user: user)
      end
    end
  end
end
