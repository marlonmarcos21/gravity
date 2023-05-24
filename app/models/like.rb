# == Schema Information
#
# Table name: likes
#
#  id             :bigint           not null, primary key
#  trackable_type :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  trackable_id   :bigint
#  user_id        :bigint
#
# Indexes
#
#  index_likes_on_trackable_type_and_trackable_id  (trackable_type,trackable_id)
#  index_likes_on_user_id                          (user_id)
#

class Like < ApplicationRecord
  belongs_to :user
  belongs_to :trackable, polymorphic: true

  validates :user, presence: true, uniqueness: { scope: [:trackable_id, :trackable_type] }
end
