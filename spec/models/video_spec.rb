# == Schema Information
#
# Table name: videos
#
#  id              :integer          not null, primary key
#  attachable_type :string
#  key             :string
#  source_meta     :json
#  token           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  attachable_id   :integer
#
# Indexes
#
#  index_videos_on_attachable_type_and_attachable_id  (attachable_type,attachable_id)
#
require 'rails_helper'

RSpec.describe Video, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
