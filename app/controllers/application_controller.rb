class ApplicationController < ActionController::Base
  # Allow modern browser versions (verify the implementation of this method).
  allow_browser versions: :modern

  # Set the current user for this session.
  before_action :set_current_user
  helper_method :current_user, :user_signed_in?

  private
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def set_current_user
    Current.user = current_user
  end

  def user_signed_in?
    !!current_user
  end
  helper_method :user_signed_in? # Expose the method to views.

  def authenticate_user!
    unless user_signed_in?
      flash[:alert] = "You must be logged in to access this page"
      redirect_to new_session_path
    end
  end

  def login(user)
    reset_session
    session[:user_id] = user.id
    Current.user = user
  end

  def logout
    Current.user = nil
    reset_session
  end


  
end
