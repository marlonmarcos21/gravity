# t.string     :email
# t.string     :encrypted_password
# t.string     :reset_password_token
# t.datetime   :reset_password_sent_at
# t.datetime   :remember_created_at
# t.integer    :sign_in_count,         default: 0
# t.datetime   :current_sign_in_at
# t.datetime   :last_sign_in_at
# t.inet       :current_sign_in_ip
# t.inet       :last_sign_in_ip
# t.boolean    :active,                default: true
# t.attachment :profile_photo
# t.string     :first_name
# t.string     :last_name

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable

  DEFAULT_AVATAR = 'https://static-prod.gravity.ph/dev_files/default-avatar.png'.freeze

  has_one :user_profile, dependent: :destroy, inverse_of: :user

  has_many :posts
  has_many :blogs
  has_many :likes

  has_many :friends
  has_many :friend_requests
  has_many :requested_friends, class_name: 'FriendRequest', foreign_key: :requester_id

  has_attached_file :profile_photo, styles: { thumb: { geometry: '150x150#', processors: [:thumbnail] } },
                                    storage: :s3,
                                    s3_credentials: "#{Rails.root}/config/s3.yml",
                                    s3_region: ENV['AWS_S3_REGION'],
                                    s3_protocol: :https,
                                    default_url: DEFAULT_AVATAR

  validates_attachment_content_type :profile_photo, content_type: %r{\Aimage/.*\Z}

  validates :first_name, presence: true
  validates :last_name,  presence: true

  extend FriendlyId::FinderMethods
  extend FriendlyId
  friendly_id :slug_candidates

  include PgSearch
  pg_search_scope :search,
                  against: [:first_name, :last_name],
                  using:   { tsearch: { prefix: true, tsvector_column: 'tsv_name' },
                             trigram: { threshold: 0.6 } }

  include PublicActivity::Model
  tracked skip_defaults: true,
          owner: proc { |controller, _model| controller.current_user },
          recipient: proc { |_controller, model| model }

  delegate :date_of_birth,   to: :user_profile, allow_nil: true
  delegate :street_address1, to: :user_profile, allow_nil: true
  delegate :street_address2, to: :user_profile, allow_nil: true
  delegate :city,            to: :user_profile, allow_nil: true
  delegate :state,           to: :user_profile, allow_nil: true
  delegate :country,         to: :user_profile, allow_nil: true
  delegate :postal_code,     to: :user_profile, allow_nil: true
  delegate :phone_number,    to: :user_profile, allow_nil: true
  delegate :mobile_number,   to: :user_profile, allow_nil: true

  delegate :date_of_birth=,   to: :user_profile
  delegate :street_address1=, to: :user_profile
  delegate :street_address2=, to: :user_profile
  delegate :city=,            to: :user_profile
  delegate :state=,           to: :user_profile
  delegate :country=,         to: :user_profile
  delegate :postal_code=,     to: :user_profile
  delegate :phone_number=,    to: :user_profile
  delegate :mobile_number=,   to: :user_profile

  accepts_nested_attributes_for :user_profile

  scope :active, -> { where(active: true) }

  # Overrides devise methods
  def active_for_authentication?
    super && active?
  end

  def send_devise_notification(notification, *args)
    devise_mailer.delay.send(notification, self, *args)
  end
  # End override devise methods

  def name
    "#{first_name} #{last_name}"
  end

  def full_address
    [
      street_address1,
      street_address2,
      ',',
      city,
      ',',
      state,
      country,
      postal_code
    ].compact.join(' ').gsub(' ,', ',').gsub(/,,|, ,/, ',').gsub(/^ , |^,$/, '')
  end

  def is_friends_with?(other_user)
    friends.where(friend: other_user).exists?
  end

  def send_friend_request_to(other_user)
    friend_request = other_user.friend_request_from(self, %w(canceled rejected))
    if friend_request
      friend_request.update(status: 'pending')
    else
      requested_friends.create(user: other_user)
    end
  end

  def requested_to_be_friends_with?(other_user)
    requested_friends.where(user: other_user, status: 'pending').exists?
  end

  def friend_request_from(other_user, status = 'pending')
    friend_requests.find_by(requester: other_user, status: status)
  end

  def has_friend_request_from?(other_user)
    !friend_request_from(other_user).nil?
  end

  def accept_friend_request!(other_user)
    friend_request = friend_request_from(other_user)
    return false unless friend_request
    friends.create(
      friend: other_user,
      friend_request: friend_request
    )
    other_user.friends.create(
      friend: self,
      friend_request: friend_request
    )
    friend_request.update(status: 'accepted')
  end

  def cancel_friend_request!(other_user)
    friend_request = other_user.friend_request_from(self)
    return false unless friend_request
    friend_request.update(status: 'canceled')
  end

  def reject_friend_request!(other_user)
    friend_request = friend_request_from(other_user)
    return false unless friend_request
    friend_request.update(status: 'rejected')
  end

  def profile_photo_url(style = :original)
    profile_photo.url(style).sub("#{ENV['AWS_S3_HOST_NAME']}/", '')
  end

  def activities_as_recipient
    Activity.where(recipient: self)
  end

  private

  def slug_candidates
    "#{first_name}-#{last_name}"
  end

  def should_generate_new_friendly_id?
    slug.blank? || first_name_changed? || last_name_changed?
  end
end
