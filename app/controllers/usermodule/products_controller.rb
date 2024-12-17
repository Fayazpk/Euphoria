class Usermodule::ProductsController < ApplicationController
    def index
      category = Category.find_by(id: params[:category_id])
      if category
        @subcategory = category.subcategories.find_by(id: params[:subcategory_id])
        if @subcategory
          @products = @subcategory.products
        else
          flash[:alert] = "Subcategory not found for the given category."
          redirect_to categories_path
        end
      else
        flash[:alert] = "Category not found."
        redirect_to root_path
      end
    end
  end
  