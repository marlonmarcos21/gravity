# t.string     :title
# t.text       :body
# t.boolean    :published
# t.references :user

class Post < ActiveRecord::Base
  belongs_to :user

  has_one  :main_image, -> { where(main_image: true) }, class_name: 'Image', as: :attachable
  has_many :images, as: :attachable, dependent: :destroy

  accepts_nested_attributes_for :images, allow_destroy: true

  validates :user, presence: true

  scope :recent, ->(limit) { order(created_at: :desc).limit(limit) }
end
