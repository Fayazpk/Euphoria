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
    @product.product_variants.build
    @categories = Category.all
    @subcategories = Subcategory.all
  end

  def create
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
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      redirect_to admin_products_path, alert: "Product not found."
      return
    end
  
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
    @product.destroy
    redirect_to admin_products_path, notice: "Product was successfully destroyed."
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
      images: [],
      discount_attributes: [:discount_percentage],
      product_variants_attributes: [:id, :size, :stock, :_destroy]
    )
  end
end
