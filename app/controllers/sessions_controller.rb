
class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: [:new, :create]

  def new
    redirect_to root_path if user_signed_in?
  end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      login(user)

      if user.admin?
        redirect_to admin_dashboard_path, notice: "Logged in successfully!"
      else
        redirect_to usermodule_home_index_path, notice: "Logged in successfully!"
      end
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: "Logged out successfully!"
  end

  def oauth_callback
    auth = request.env['omniauth.auth']
    @user = User.from_omniauth(auth)

  
    session[:user_id] = @user.id
    redirect_to root_path, notice: 'Successfully signed in!'
  end

  def oauth_request
    Rails.logger.info "OAuth request initiated"
    redirect_to '/auth/google_oauth2', allow_other_host: true
  end

  def failure
    redirect_to root_path, alert: 'Authentication failed.'
  end

  private

  def redirect_if_authenticated

    redirect_to usermodule_home_index_path, notice: "You are already logged in." if user_signed_in?
  end
end
