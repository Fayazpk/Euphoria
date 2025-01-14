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
   
    Size.all.each do |size|
      variant.product_variant_sizes.build(size: size)
    end
  end

  def create
    @product = Product.new(product_params)

    if @product.save
    
      process_images if params[:product][:images].present?

      redirect_to admin_products_path(@product), notice: "Product created successfully."
    else
    
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
   
    delete_images if params[:product][:delete_images].present?

    if @product.update(product_params)
     
      process_images if params[:product][:images].present?

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
      { images: [] },
      { delete_images: [] },
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

  def process_images
    return unless params[:product][:images].present?

    params[:product][:images].each do |image|
      
      next unless image.content_type.start_with?("image/")

 

      @product.images.attach(image)
    end
  end

  def delete_images
    params[:product][:delete_images].each do |image_id|
      begin
        image = @product.images[image_id.to_i]
        image.purge if image.present?
      rescue StandardError => e
        logger.error "Error deleting image #{image_id}: #{e.message}"
      end
    end
  end

 
  def validate_images
    return true if params[:product][:images].nil?

    valid = true
    total_images = @product.images.count + params[:product][:images].size

    if total_images > 4
      @product.errors.add(:images, "cannot have more than 4 images total")
      valid = false
    end

    params[:product][:images].each do |image|
      unless image.content_type.start_with?("image/")
        @product.errors.add(:images, "must be image files")
        valid = false
      end

      if image.size > 5.megabytes
        @product.errors.add(:images, "must be less than 5MB")
        valid = false
      end
    end

    valid
  end


end
