FactoryGirl.define do
  factory :friend do
    before :create do |friend, evaluator|
      if evaluator.friend_request.blank?
        friend.user = user = FactoryGirl.create(:user)
        friend.friend = new_friend = FactoryGirl.create(:user)
        friend.friend_request = FactoryGirl.create(:friend_request,
                                                   user: user,
                                                   requester: new_friend)
      else
        friend_request = evaluator.friend_request
        friend.user = friend_request.user
        friend.friend = friend_request.requester
        friend.friend_request = friend_request
      end
    end
  end
end
