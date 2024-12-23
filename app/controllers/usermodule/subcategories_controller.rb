module Usermodule
  class SubcategoriesController < ApplicationController
    def index
      @category = Category.find(params[:category_id])
      @subcategories = @category.subcategories
      
    end
  end
end
