# == Schema Information
#
# Table name: events
#
#  id              :bigint           not null, primary key
#  og_image_source :text
#  published       :boolean          default(FALSE)
#  published_at    :datetime
#  slug            :string
#  title           :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_events_on_slug     (slug)
#  index_events_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class Event < ApplicationRecord
  belongs_to :user

  has_many :rsvps, dependent: :destroy

  has_rich_text :body

  extend FriendlyId::FinderMethods
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  def publish!
    update(published: true, published_at: Time.zone.now)
  end

  def unpublish!
    update(published: false, published_at: nil)
  end

  def date_meta
    datetime = published_at || updated_at
    datetime.strftime '%a, %b %e, %Y %R'
  end
end
