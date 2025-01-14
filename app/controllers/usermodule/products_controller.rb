class Usermodule::ProductsController < ApplicationController
  before_action :set_category_and_subcategory, only: [:index, :show]
  before_action :find_product, only: [:show]

  def index
    @products = @subcategory.products
    @products = @products.order(sort_order(params[:sort]))
    @products = @products.where("base_price >= ?", params[:min_price]) if params[:min_price].present?
    @products = @products.where("base_price <= ?", params[:max_price]) if params[:max_price].present?
    if params[:query].present?
      @products = @products.where("name ILIKE ?", "%#{params[:query]}%")
    end
  end

  
  def search
    if params[:query].present?
      @products = Product.where('name ILIKE ?', "%#{params[:query]}%")
                        .limit(10)
                        .select(:id, :name)  # Only select needed fields
      
      render json: @products.map { |product| {
        id: product.id,
        name: product.name
      }}
    else
      render json: []
    end
  end

  
  private

  SORT_OPTIONS = %w[ price_asc price_desc newest discount].freeze

  def set_category_and_subcategory
    @category = Category.find_by(id: params[:category_id])
    unless @category
      flash[:alert] = "Category not found."
      redirect_to root_path and return
    end

    @subcategory = @category.subcategories.find_by(id: params[:subcategory_id])
    unless @subcategory
      flash[:alert] = "Subcategory not found for the given category."
      redirect_to categories_path and return
    end
  end

  def find_product
    @product = @subcategory.products.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Product not found."
    redirect_to usermodule_category_subcategory_products_path(@category, @subcategory)
  end

  def sort_order(option)
    case option
    
    when "price_asc" then { base_price: :asc }
    when "price_desc" then { base_price: :desc }
    when "newest" then { created_at: :desc }
    when "discount" then { discount_percentage: :desc }
    else { created_at: :desc }
    end
  end
end
