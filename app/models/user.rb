class User < ApplicationRecord
    has_secure_password
  
    validates :email, presence: true
    validates :password, presence: true, length: { minimum: 6 }
    validates :password_confirmation, presence: true
  
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
  end
  