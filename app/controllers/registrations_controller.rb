class RegistrationsController < ApplicationController
  before_action :find_user, only: [:verify_otp, :verify_otp_submission]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    Rails.logger.debug { "User initialized: #{@user.inspect}" }

    if @user.save
      @user.generate_otp
      UserMailer.send_otp(@user).deliver_now
      redirect_to verify_otp_registration_path(@user.id), notice: "Please check your email for the OTP."
    else
      Rails.logger.debug { "Errors: #{@user.errors.full_messages}" }
      flash[:alert] = @user.errors.full_messages.join(", ")
      render :new
    end
  end

  def verify_otp
    # Ensure params[:user] is present
    if params[:user].nil?
      flash[:alert] = "OTP submission is missing."
      render :verify_otp and return
    end
  
    submitted_otp = params[:user][:otp]  # Access OTP from params[:user][:otp]
  
    if submitted_otp.blank?
      flash[:alert] = "OTP cannot be blank."
      render :verify_otp and return
    end
  
    if @user.otp_code == submitted_otp && @user.otp_expires_at > Time.current
      flash[:notice] = "OTP verified successfully!"
      redirect_to usermodule_home_index_path  # Replace with your desired path
    else
      flash[:alert] = "Invalid or expired OTP."
      Rails.logger.debug { "Expected OTP: #{@user.otp_code}, Submitted OTP: #{submitted_otp}" }
      Rails.logger.debug { "OTP Expiration: #{@user.otp_expires_at}" }
      render :verify_otp
    end
  end
  
  

  private

  def find_user
    @user = User.find_by(id: params[:id]) # Ensure :id is used for finding user
    unless @user
      flash[:alert] = "User not found"
      redirect_to new_registration_path
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
