# t.string     :title
# t.text       :body
# t.boolean    :published
# t.references :user
# t.datetime   :published_at

class Post < ActiveRecord::Base
  belongs_to :user

  has_one  :main_image, -> { where(main_image: true) }, class_name: 'Image', as: :attachable
  has_many :images, as: :attachable, dependent: :destroy

  accepts_nested_attributes_for :images, allow_destroy: true

  validates :user, presence: true

  scope :published, -> { where(published: true) }
  scope :recent,    ->(limit) { published.order(published_at: :desc).limit(limit) }

  before_update :set_published_at, if: :published_changed?

  def publish!
    update_attribute :published, true
  end

  def unpublish!
    update_attribute :published, false
  end

  private

  def set_published_at
    return unless published?
    self.published_at = Time.zone.now
  end
end
