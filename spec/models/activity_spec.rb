# == Schema Information
#
# Table name: activities
#
#  id             :integer          not null, primary key
#  is_read        :boolean          default(FALSE)
#  key            :string
#  owner_type     :string
#  parameters     :text
#  recipient_type :string
#  trackable_type :string
#  created_at     :datetime
#  updated_at     :datetime
#  owner_id       :integer
#  recipient_id   :integer
#  trackable_id   :integer
#
# Indexes
#
#  index_activities_on_owner_id_and_owner_type          (owner_id,owner_type)
#  index_activities_on_recipient_id_and_recipient_type  (recipient_id,recipient_type)
#  index_activities_on_trackable_id_and_trackable_type  (trackable_id,trackable_type)
#
require 'rails_helper'

RSpec.describe Activity, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
