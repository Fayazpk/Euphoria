class User < ApplicationRecord
  has_secure_password validations: false

  validates :email, presence: { message: "is required" }, format: { with: /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\z/, message: "must be a valid email address" }, unless: :oauth_login?
  validates :password, presence: { message: "is required" }, length: { minimum: 6, message: "must be at least 6 characters long" },
                       format: { with: /(?=.*[a-z])(?=.*[A-Z])(?=.*[\W_])/, message: "must include at least one uppercase letter, one lowercase letter, and one special character" }, unless: :oauth_login?
  validates :password_confirmation, presence: { message: "is required" }, unless: :oauth_login?

  attr_accessor :oauth_login

  # Establishes the relationship with the Address model
  has_many :addresses, dependent: :destroy
  accepts_nested_attributes_for :addresses

  def self.from_omniauth(auth)
    user = find_or_initialize_by(provider: auth.provider, uid: auth.uid)
    user.email = auth.info.email
    user.name = auth.info.name  # Assuming you have a name field
    user.password = SecureRandom.hex(10)  # Generate a random password
    user.oauth_login = true
    user.save!
    user
  end

  # Change visibility to public for OTP generation method
  def generate_otp
    self.otp_code = SecureRandom.hex(3)
    self.otp_expires_at = 1.minutes.from_now
    Rails.logger.info "Generated OTP: #{otp_code}, Expires At: #{otp_expires_at}"
    save!
  end

  def validate_otp?(otp)
    self.otp_code == otp && self.otp_expires_at > Time.current
  end

  def clear_otp
    update!(otp_code: nil, otp_expires_at: nil) # Clear OTP after validation
  end

  # Define the oauth_login? method
  def oauth_login?
    !!@oauth_login
  end

  def user_addresses
    user = User.find(user_id)
    user.addresses
  end
end
