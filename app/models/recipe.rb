# t.string     :title
# t.boolean    :published, default: false
# t.references :user,      index: true
# t.references :category,  index :true
# t.datetime   :published_at

class Recipe < ApplicationRecord
  belongs_to :user
  belongs_to :category, class_name: 'RecipeCategory'

  has_rich_text :description
  has_rich_text :ingredients
  has_rich_text :instructions

  extend FriendlyId::FinderMethods
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  validates :title, presence: true

  scope :published,   -> { where(published: true) }
  scope :unpublished, -> { where(published: false) }
  scope :descending,  -> { order(published_at: :desc) }

  before_save :strip_title, if: :title_changed?

  def stripped_teaser
    html = Nokogiri::HTML.fragment(description.body.to_s)
    attachments = html.search('action-text-attachment')
    attachments.each(&:remove)
    teaser = html.to_html

    teaser += '<h4>Ingredients</h4>'

    html = Nokogiri::HTML.fragment(ingredients.body.to_s)
    attachments = html.search('action-text-attachment')
    attachments.each(&:remove)
    teaser += html.to_html

    teaser += '<i>Read more . . .</i>'

    teaser
  end

  def image_preview
    html = Nokogiri::HTML.fragment(description.body.to_s)
    img = html.search('img').first
    return '' unless img

    img.set_attribute('style', 'max-width: 300px;')
    img.remove_attribute('width')
    img.remove_attribute('height')
    img.to_html
  end

  def publish!
    update(published: true, published_at: Time.zone.now)
  end

  def unpublish!
    update(published: false, published_at: nil)
  end

  def date_meta
    published_at.strftime '%a, %b %e, %Y %R'
  end

  private

  def strip_title
    title.strip!
  end

  def should_generate_new_friendly_id?
    return if published? && !slug.blank?

    slug.blank? || title_changed?
  end
end
