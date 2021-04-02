# t.string     :title
# t.boolean    :published, default: false
# t.references :user, index: true

class Recipe < ApplicationRecord
  belongs_to :user

  has_rich_text :ingredients
  has_rich_text :instructions

  extend FriendlyId::FinderMethods
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  validates :title, presence: true

  def publish!
    update_attribute published: true
  end

  def unpublish!
    update_attribute :published, false
  end

  private

  def should_generate_new_friendly_id?
    return if published? && !slug.blank?

    slug.blank? || title_changed?
  end
end
