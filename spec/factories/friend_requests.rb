FactoryBot.define do
  factory :friend_request do
    user      { FactoryBot.create(:user) }
    requester { FactoryBot.create(:user) }
  end
end
