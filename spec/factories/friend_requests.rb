FactoryGirl.define do
  factory :friend_request do
    user      { FactoryGirl.create(:user) }
    requester { FactoryGirl.create(:user) }
  end
end
