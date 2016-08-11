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

class User < ActiveRecord::Base
  DEFAULT_AVATAR = 'https://themarcoses-dev.s3-ap-southeast-1.amazonaws.com/dev_files/default-avatar.png'

  has_one :user_profile, dependent: :destroy, inverse_of: :user

  has_many :posts
  has_many :blogs

  has_attached_file :profile_photo, styles: { thumb: { geometry: '150x150#', processors: [:thumbnail] } },
                                    storage: :s3,
                                    s3_credentials: "#{Rails.root}/config/s3.yml",
                                    s3_region: ENV['AWS_S3_REGION'],
                                    s3_protocol: :https,
                                    default_url: DEFAULT_AVATAR

  validates_attachment_presence :profile_photo
  validates_attachment_content_type :profile_photo, content_type: /\Aimage\/.*\Z/

  validates :first_name, presence: true
  validates :last_name, presence: true

  include PgSearch
  pg_search_scope :search,
                  against: [:first_name, :last_name],
                  using:   { tsearch: { prefix: true, tsvector_column: 'tsv_name' },
                             trigram: { threshold: 0.6 } }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable

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
end
