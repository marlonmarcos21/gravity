# == Schema Information
#
# Table name: friends
#
#  id                :integer          not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  friend_id         :integer
#  friend_request_id :integer
#  user_id           :integer
#
# Indexes
#
#  index_friends_on_friend_id          (friend_id)
#  index_friends_on_friend_request_id  (friend_request_id)
#  index_friends_on_user_id            (user_id)
#
require 'rails_helper'

RSpec.describe Friend, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
