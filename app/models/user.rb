# t.string   :email
# t.string   :encrypted_password
# t.string   :reset_password_token
# t.datetime :reset_password_sent_at
# t.datetime :remember_created_at
# t.integer  :sign_in_count,         default: 0
# t.datetime :current_sign_in_at
# t.datetime :last_sign_in_at
# t.inet     :current_sign_in_ip
# t.inet     :last_sign_in_ip
# t.boolean  :active,                default: true

class User < ActiveRecord::Base
  has_one :user_profile, dependent: :destroy, inverse_of: :user

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable

  delegate :first_name,      to: :user_profile, allow_nil: true
  delegate :last_name,       to: :user_profile, allow_nil: true
  delegate :date_of_birth,   to: :user_profile, allow_nil: true
  delegate :street_address1, to: :user_profile, allow_nil: true
  delegate :street_address2, to: :user_profile, allow_nil: true
  delegate :city,            to: :user_profile, allow_nil: true
  delegate :state,           to: :user_profile, allow_nil: true
  delegate :country,         to: :user_profile, allow_nil: true
  delegate :postal_code,     to: :user_profile, allow_nil: true
  delegate :phone_number,    to: :user_profile, allow_nil: true
  delegate :mobile_number,   to: :user_profile, allow_nil: true

  delegate :first_name=,      to: :user_profile
  delegate :last_name=,       to: :user_profile
  delegate :date_of_birth=,   to: :user_profile
  delegate :street_address1=, to: :user_profile
  delegate :street_address2=, to: :user_profile
  delegate :city=,            to: :user_profile
  delegate :state=,           to: :user_profile
  delegate :country=,         to: :user_profile
  delegate :postal_code=,     to: :user_profile
  delegate :phone_number=,    to: :user_profile
  delegate :mobile_number=,   to: :user_profile

  # Overrides devise methods
  def active_for_authentication?
    super && active?
  end
end
