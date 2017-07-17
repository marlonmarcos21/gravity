FactoryGirl.define do
  factory :comment do
    body { Faker::Lorem.sentence(1) }
    commentable { FactoryGirl.create(:post) }
    user { FactoryGirl.create(:user) }
  end
end
