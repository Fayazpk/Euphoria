module Usermodule
  class HomeController < ApplicationController
    before_action :authenticate_user!

    def index
      Rails.logger.info("User home page accessed")
      @categories = Category.all
      @product = Product.all
    end
  end
end 