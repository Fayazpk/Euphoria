class Admin::ProductsController < ApplicationController
  layout "admin"
  before_action :set_product, only: %i[show edit update destroy]
  before_action :load_categories_and_subcategories, only: %i[new edit create update]

  def index
    @products = Product.includes(:category, :subcategory, :product_variants)
                      .order(created_at: :desc)
  end

  def new
    @product = Product.new
    variant = @product.product_variants.build
    # Initialize product variant sizes for each size
    Size.all.each do |size|
      variant.product_variant_sizes.build(size: size)
    end
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to admin_product_path(@product), notice: "Product created successfully."
    else
      # Rebuild the form structure if validation fails
      variant = @product.product_variants.first || @product.product_variants.build
      Size.all.each do |size|
        variant.product_variant_sizes.find_or_initialize_by(size: size)
      end
      render :new
    end
  end

  def edit
    if @product.product_variants.empty?
      variant = @product.product_variants.build
      Size.all.each do |size|
        variant.product_variant_sizes.build(size: size)
      end
    end
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
      redirect_to admin_products_path, notice: "Product was successfully deleted."
    else
      redirect_to admin_products_path, alert: "Failed to delete product."
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def load_categories_and_subcategories
    @categories = Category.all
    @subcategories = Subcategory.all
  end

  def product_params
    params.require(:product).permit(
      :name,
      :description,
      :category_id,
      :subcategory_id,
      :base_price,
      :discount_percentage,
      images: [],
      product_variants_attributes: [
        :id,
        :_destroy,
        product_variant_sizes_attributes: [
          :id,
          :size_id,
          :stock,
          :_destroy
        ]
      ]
    )
  end
end
