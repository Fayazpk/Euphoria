class Usermodule::ProductviewsController < ApplicationController
  def index
    @category = Category.find(params[:category_id])
    @subcategory = @category.subcategories.find(params[:subcategory_id])
    @product = @subcategory.products.find(params[:product_id])
    @variants = @product.product_variants.includes(:sizes)
    @related = @subcategory.products.where.not(id: @product.id).limit(5)

  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Product not found."
    redirect_to usermodule_category_subcategory_products_path(@category, @subcategory)
  end
end
