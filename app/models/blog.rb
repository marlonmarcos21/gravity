# t.string     :title
# t.text       :body
# t.boolean    :published
# t.datetime   :published_at
# t.references :user,        index: true
# t.string     :slug

class Blog < ActiveRecord::Base
  belongs_to :user

  has_many :images, as: :attachable, dependent: :destroy

  validates :user, presence: true

  scope :published, -> { where(published: true) }
  scope :recent,    ->(limit) { published.order(published_at: :desc).limit(limit) }

  before_save :strip_title, if: :title_changed?

  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  private

  def strip_title
    title.strip!
  end

  def should_generate_new_friendly_id?
    return if published? && !slug.blank?
    slug.blank? || title_changed?
  end
end
