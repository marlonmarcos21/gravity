# == Schema Information
#
# Table name: friend_requests
#
#  id           :integer          not null, primary key
#  status       :string           default("pending")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  requester_id :integer
#  user_id      :integer
#
# Indexes
#
#  index_friend_requests_on_requester_id  (requester_id)
#  index_friend_requests_on_user_id       (user_id)
#
require 'rails_helper'

RSpec.describe FriendRequest, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
