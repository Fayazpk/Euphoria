class Admin::CouponsController < ApplicationController
  before_action :set_admin_coupon, only: %i[show edit update destroy]
  layout 'admin'

  def index
    @admin_coupons = Coupon.all
  end

  def show
  end

  def new
    @admin_coupon = Coupon.new
  end

  def edit
  end

  def create
    @admin_coupon = Coupon.new(coupon_params)  # Changed method name

    respond_to do |format|
      if @admin_coupon.save
        format.html { redirect_to admin_coupon_path(@admin_coupon), notice: "Coupon was successfully created." }
        format.json { render :show, status: :created, location: @admin_coupon }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin_coupon.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @admin_coupon.update(coupon_params)  # Changed method name
        format.html { redirect_to admin_coupon_path(@admin_coupon), notice: "Coupon was successfully updated." }
        format.json { render :show, status: :ok, location: @admin_coupon }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @admin_coupon.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @admin_coupon.destroy!

    respond_to do |format|
      format.html { redirect_to admin_coupons_path, status: :see_other, notice: "Coupon was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_admin_coupon
      @admin_coupon = Coupon.find(params[:id])  # Simplified params requirement
    end

    def coupon_params  # Changed method name and params requirement
      params.require(:coupon).permit(:code, :discount, :description, :valid_from, :valid_until, :max_usage, :status)
    end
end