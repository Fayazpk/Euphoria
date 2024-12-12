class Admin::SubcategoriesController < ApplicationController
  layout 'admin'
  before_action :set_admin_subcategory, only: %i[show edit update destroy]

  # GET /admin/subcategories or /admin/subcategories.json
  def index
    @admin_subcategories = Subcategory.page(params[:page]).per(25)
  end

  # GET /admin/subcategories/1 or /admin/subcategories/1.json
  def show
  end

  # GET /admin/subcategories/new
  def new
    @admin_subcategory = Subcategory.new
    @categories = Category.all
  end

  # GET /admin/subcategories/1/edit
  def edit
  end

  # POST /admin/subcategories or /admin/subcategories.json
  def create
    @admin_subcategory = Subcategory.new(admin_subcategory_params)
    @categories = Category.all

    respond_to do |format|
      if @admin_subcategory.save
        format.html { redirect_to admin_subcategories_path, notice: "Subcategory was successfully created." }
        format.json { render :show, status: :created, location: @admin_subcategory }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin_subcategory.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/subcategories/1 or /admin/subcategories/1.json
  def update
    respond_to do |format|
      if @admin_subcategory.update(admin_subcategory_params)
        format.html { redirect_to @admin_subcategory, notice: "Subcategory was successfully updated." }
        format.json { render :show, status: :ok, location: @admin_subcategory }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @admin_subcategory.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/subcategories/1 or /admin/subcategories/1.json
  def destroy
    if @admin_subcategory.destroy
      respond_to do |format|
        format.html { redirect_to admin_subcategories_path, status: :see_other, notice: "Subcategory was successfully destroyed." }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to admin_subcategories_path, alert: "Failed to destroy subcategory." }
        format.json { render json: { error: "Failed to destroy subcategory" }, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_admin_subcategory
    @admin_subcategory = Subcategory.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def admin_subcategory_params
    params.require(:subcategory).permit(:name, :description, :category_id, :image)
  end
end
