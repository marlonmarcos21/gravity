# == Schema Information
#
# Table name: blogs
#
#  id           :integer          not null, primary key
#  body         :text
#  published    :boolean          default(FALSE)
#  published_at :datetime
#  slug         :string
#  title        :string
#  tsv_name     :tsvector
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer
#
# Indexes
#
#  index_blogs_on_slug      (slug)
#  index_blogs_on_tsv_name  (tsv_name) USING gin
#  index_blogs_on_user_id   (user_id)
#

class Blog < ApplicationRecord
  belongs_to :user

  has_many :blog_media, as: :attachable, dependent: :destroy

  validate :validate_publishing

  has_paper_trail on: :update, only: %i(title body)

  scope :published,   -> { where(published: true) }
  scope :unpublished, -> { where(published: false) }
  scope :recent,      ->(limit) { published.order(published_at: :desc).limit(limit) }
  scope :descending,  -> { order(published_at: :desc) }

  before_save :strip_title, if: :title_changed?

  before_update :set_published_at, if: :published_changed?

  include AsLikeable
  include BlogView

  extend FriendlyId::FinderMethods
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  include PgSearch::Model
  pg_search_scope :search,
                  against: :title,
                  using: {
                    tsearch: { prefix: true, tsvector_column: 'tsv_name' },
                    trigram: { threshold: 0.2 }
                  },
                  order_within_rank: 'blogs.published_at DESC'

  acts_as_commentable

  include PublicActivity::Model
  tracked skip_defaults: true,
          owner: proc { |controller, _model| controller.current_user },
          recipient: proc { |_controller, model| model.user }

  def publish!
    update published: true
  end

  def unpublish!
    update_attribute :published, false
  end

  def date_meta
    datetime = published_at || updated_at
    datetime.strftime '%a, %b %e, %Y %R'
  end

  def publishable?
    !title.blank? && body.length >= 800
  end

  private

  def publishing?
    return false unless published_changed?

    !published_was && published?
  end

  def validate_publishing
    return unless publishing?

    errors.add(:title, %(can't be blank when publising)) if title.blank?
    errors.add(:body, %(must be at least 800 characters)) if body.length < 800
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
