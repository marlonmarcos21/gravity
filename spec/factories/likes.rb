FactoryBot.define do
  factory :like do
    user
    trackable { FactoryBot.create(:post) }
  end
end
