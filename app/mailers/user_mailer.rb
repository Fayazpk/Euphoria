class UserMailer < ApplicationMailer
    default from: ENV['DEFAULT_EMAIL']
  
    def send_otp(user)
      @user = user
      @otp = @user.otp_code  # Ensure you're accessing otp_code correctly
      mail(to: @user.email, subject: 'Your Login OTP') do |format|
        format.text { render plain: "Your OTP is: #{@otp}" }
        format.html { render html: "<p>Your OTP is: <strong>#{@otp}</strong></p>".html_safe }
      end
    end
  end
  