# == Schema Information
#
# Table name: recipes
#
#  id           :bigint           not null, primary key
#  published    :boolean          default(FALSE)
#  published_at :datetime
#  slug         :string
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  category_id  :bigint
#  user_id      :bigint
#
# Indexes
#
#  index_recipes_on_category_id  (category_id)
#  index_recipes_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => recipe_categories.id)
#

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
    html.to_html
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
    datetime = published_at || updated_at
    datetime.strftime '%a, %b %e, %Y %R'
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
