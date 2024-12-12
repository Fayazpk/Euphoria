class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: [:new, :create, :oauth_request]

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

  def oauth_request
    # Only redirect to the OAuth provider if not already signed in.
    if user_signed_in?
      redirect_to usermodule_home_index_path, notice: "You are already logged in."
    else
      # Redirect to the OAuth provider path
      redirect_to "/auth/#{params[:provider]}"
    end
  end

  def oauth_callback
    auth = request.env['omniauth.auth']
    Rails.logger.debug "OmniAuth Auth Hash: #{auth.inspect}"

    if auth
      # Find or create the user using provider data
      user = User.find_or_create_by(provider: auth['provider'], uid: auth['uid']) do |u|
        u.email = auth['info']['email']
        u.name = auth['info']['name']
        u.password = SecureRandom.hex(16) # Random password for OAuth login
      end

      login(user)
      redirect_to usermodule_home_index_path, notice: "Logged in successfully!"
    else
      redirect_to new_session_path, alert: "Authentication failed"
    end
  end

  private

  def redirect_if_authenticated
    # Ensure users can't access the login or OAuth request pages if they're already logged in
    redirect_to usermodule_home_index_path, notice: "You are already logged in." if user_signed_in? && !request.path.include?("/auth/")
  end
end
