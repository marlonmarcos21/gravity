# == Schema Information
#
# Table name: chat_groups
#
#  id             :bigint           not null, primary key
#  chat_room_name :string
#  is_group_chat  :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require 'rails_helper'

RSpec.describe Chat::Group, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
