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

  scope :published,   ->{ where(published: true) }
  scope :unpublished, ->{ where(published: false) }
  scope :recent,      ->(limit) { published.order(published_at: :desc).limit(limit) }
  scope :descending,  ->{ order(published_at: :desc) }

  before_save :strip_title,        if: :title_changed?
  before_update :set_published_at, if: :published_changed?

  include BlogView

  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  include PgSearch
  pg_search_scope :search,
                  against: :title,
                  using:   { tsearch: { prefix: true, tsvector_column: 'tsv_name' },
                             trigram: { threshold: 0.2 } },
                  order_within_rank: 'blogs.published_at DESC'

  def publish!
    return update_attribute :published, true if publishable?
    errors.add(:title, %(can't be blank when publising)) if title.blank?
    errors.add(:body, %(must be at least 800 characters)) if body.length < 800
    false
  end

  def unpublish!
    update_attribute :published, false
  end

  def date_meta
    datetime = published_at || updated_at
    datetime.strftime '%a, %b %e, %Y %R'
  end

  private

  def publishable?
    !title.blank? && body.length >= 800
  end

  def strip_title
    title.strip!
  end

  def set_published_at
    return unless published?
    self.published_at = Time.zone.now
  end

  def should_generate_new_friendly_id?
    return if published? && !slug.blank?
    slug.blank? || title_changed?
  end
end
