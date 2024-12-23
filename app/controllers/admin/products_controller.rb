class Admin::ProductsController < ApplicationController
  layout 'admin'
  before_action :set_product, only: %i[show edit update destroy]

  def index
    @cat = Category.all
    @products = Product.includes(:category, :subcategory, :product_variants)
                       .order(created_at: :desc)
  end

  def new
    @product = Product.new
    @product.product_variants.build 
    @categories = Category.all
    @subcategories = Subcategory.all
  end

  def create
    Rails.logger.info("Product Params: #{params[:product].inspect}")
    @product = Product.new(product_params)
    if @product.save
      redirect_to admin_product_path(@product), notice: 'Product created successfully.'
    else
      
      @categories = Category.all
      @subcategories = Subcategory.all
      render :new
    end
  end

  def edit
    @categories = Category.all
    @subcategories = Subcategory.all
    @product.product_variants.build if @product.product_variants.empty?
  end

  def update
    if @product.update(product_params)
      redirect_to admin_product_path(@product), notice: "Product was successfully updated."
    else
      render :edit
    end
  end

  def destroy
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
      :name, :description, :category_id, :subcategory_id,
      :base_price, :discount_percentage, images: [],
      product_variants_attributes: [:size, :stock, :id, :_destroy]
      
    )
  end
end
