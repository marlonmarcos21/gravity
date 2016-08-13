# t.text       :body
# t.boolean    :published
# t.references :user
# t.datetime   :published_at
# t.boolean    :private

class Post < ActiveRecord::Base
  belongs_to :user

  has_one  :main_image, -> { where(main_image: true) }, class_name: 'Image', as: :attachable
  has_many :images, as: :attachable, dependent: :destroy

  accepts_nested_attributes_for :images, allow_destroy: true

  validates :user, presence: true

  scope :published,   ->{ where(published: true) }
  scope :unpublished, ->{ where(published: false) }
  scope :recent,      ->(limit) { published.order(published_at: :desc).limit(limit) }
  scope :descending,  ->{ order(published_at: :desc) }
   
  before_save   :strip_body,       if: :body_changed?
  before_update :set_published_at, if: :published_changed?

  include PostView

  include PgSearch
  pg_search_scope :search,
                  against: :body,
                  using:   { tsearch: { prefix: true, tsvector_column: 'tsv_name' },
                             trigram: { threshold: 0.2 } },
                  order_within_rank: 'posts.published_at DESC'

  acts_as_commentable

  def publish!
    return update_attribute :published, true if publishable?
    errors.add(:title, %(can't be blank when publising)) if title.blank?
    errors.add(:body, %(can't be blank when publising)) if body.blank?
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
    !body.blank?
  end

  def strip_body
    body.strip!
  end

  def set_published_at
    return if published_at?
    return unless published?
    self.published_at = Time.zone.now
  end
end
