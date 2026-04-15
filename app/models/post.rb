# == Schema Information
#
# Table name: posts
#
#  id           :integer          not null, primary key
#  body         :text
#  public       :boolean          default(FALSE)
#  published    :boolean          default(TRUE)
#  published_at :datetime
#  slug         :string
#  tsv_name     :tsvector
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer
#
# Indexes
#
#  index_posts_on_public    (public)
#  index_posts_on_tsv_name  (tsv_name) USING gin
#  index_posts_on_user_id   (user_id)
#

class Post < ApplicationRecord
  belongs_to :user

  has_one :main_image,
          -> { where(main_image: true) },
          class_name: 'Image',
          as: :attachable,
          inverse_of: :attachable,
          dependent: nil

  has_many :images, as: :attachable, dependent: :destroy
  has_many :videos, as: :attachable, dependent: :destroy

  accepts_nested_attributes_for :images, allow_destroy: true

  validates :body, presence: true
  validates :user, presence: true

  has_paper_trail on: :update, only: :body

  before_save :unfurl_tiktok_short_url

  scope :published,       -> { where(published: true) }
  scope :unpublished,     -> { where(published: false) }
  scope :descending,      -> { order(published_at: :desc) }
  scope :recent,          ->(limit) { published.descending.limit(limit) }
  scope :is_public,       -> { where(public: true) }
  scope :all_viewable,    -> { includes(:user).published.descending }
  scope :for_public_view, -> { all_viewable.is_public }

  before_save :strip_body, if: :body_changed?

  before_create :set_published_at

  include AsLikeable
  include PostView
  include PgSearch::Model
  pg_search_scope :search,
                  against: :body,
                  using: {
                    tsearch: { prefix: true, tsvector_column: 'tsv_name' },
                    trigram: { threshold: 0.2 }
                  },
                  order_within_rank: 'posts.published_at DESC'

  acts_as_commentable

  include PublicActivity::Model
  tracked skip_defaults: true,
          owner: proc { |controller, _model| controller.current_user },
          recipient: proc { |_controller, model| model.user }

  def date_meta
    published_at.strftime '%a, %b %e, %Y %R'
  end

  def private?
    !public?
  end

  private

  def strip_body
    body.strip!
  end

  def set_published_at
    self.published_at = Time.zone.now
  end

  def unfurl_tiktok_short_url
    return if body.strip.blank?

    html = Nokogiri::HTML.fragment(body)
    a_tags = html.search('a')
    return if a_tags.empty?

    a_tags.each do |node|
      href_value = node.attributes['href'].value
      next unless href_value.starts_with?('https://vt.tiktok.com')

      uri = URI(href_value)
      resp = Net::HTTP.get(uri)
      inner_html = Nokogiri::HTML.fragment(resp)
      inner_a = inner_html.search('a').first
      node.attributes['href'].value = inner_a.attributes['href'].value
    end

    self.body = html.to_html
  end
end
