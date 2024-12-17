class Admin::ProductsController < ApplicationController
  layout 'admin'
  before_action :set_product, only: %i[show edit update destroy]

  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
    
  end

  def new
    @product = Product.new
    @product.build_discount
    @categories = Category.all
    @subcategories = Subcategory.all
    @sizes = Size.all
  end

  def create
    @product = Product.new(product_params)
    
    if @product.save
      redirect_to admin_product_path(@product), notice: 'Product created successfully.'
    else
      @categories = Category.all
      @subcategories = Subcategory.all
      @sizes = Size.all
      render :new
    end
  end

  def edit
    @categories = Category.all
    @subcategories = Subcategory.all
    @sizes = Size.all
  end

  def update
    if @product.update(product_params)
      redirect_to admin_product_path(@product), notice: "Product was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @product = Product.find(params[:id])
    # Add dependent: :destroy to the discounts association in the Product model
    if @product.destroy
      redirect_to admin_products_path, notice: 'Product was successfully deleted.'
    else
      redirect_to admin_products_path, alert: 'Failed to delete product.'
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(
      :name,
      :description,
      :base_price,
      :category_id,
      :subcategory_id,
      :size_id,
      images: [],
      discount_attributes: [:discount_percentage]
    )
  end
end
