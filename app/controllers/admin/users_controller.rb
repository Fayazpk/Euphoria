class Admin::UsersController < ApplicationController
  layout 'admin'
  before_action :require_admin
  before_action :set_user, only: [:show, :edit, :update, :destroy, :toggle_block]
  
  def index
    @users = User.all.order(created_at: :desc)
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_user_path(@user), notice: 'User was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: 'User was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find_by(id: params[:id])
    if @user
      @user.destroy
      flash[:notice] = "User was successfully deleted."
      redirect_to admin_users_path
    else
      flash[:alert] = "User not found."
      redirect_to admin_users_path
    end
  end

  def toggle_block
    @user = User.find_by(id: params[:id]) 
    if @user
      @user.update(is_blocked: !@user.is_blocked)
      status = @user.is_blocked ? 'blocked' : 'unblocked'
      redirect_to admin_user_path(@user), notice: "User was successfully #{status}."
    else
      flash[:alert] = "User not found."
      redirect_to admin_users_path
    end
  end

  private

  def set_user
    @user = User.find(params[:id])  
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :is_blocked)
  end

  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: 'Access denied. Admin privileges required.'
    end
  end
end