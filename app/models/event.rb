# t.string     :title
# t.boolean    :published
# t.references :user
# t.datetime   :published_at

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
