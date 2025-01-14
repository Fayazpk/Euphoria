module Usermodule
    class WishlistsController < ApplicationController
      before_action :set_product, only: [:create, :destroy]
    
      def index
        @wishlist_items = current_user.wishlist_products.includes(:subcategory, :category, images_attachments: :blob)
      end
    
      def create
        @wishlist = current_user.wishlists.new(product: @product)
    
        if @wishlist.save
          render json: {
            success: true,
            message: "Item added to wishlist",
            is_wishlisted: true
          }
        else
          render json: {
            success: false,
            message: "Item addition to wishlist failed",
            is_wishlisted: false
          }, status: :unprocessable_entity
        end
      end
    
      def destroy
        @wishlist = current_user.wishlists.find_by(product: @product)
    
        if @wishlist&.destroy
          render json: {
            success: true,
            message: "Item deleted from wishlist",
            is_wishlisted: false
          }
        else
          render json: {
            success: false,
            message: "Item deletion from wishlist failed"
          }, status: :unprocessable_entity
        end
      end
    
      private
      def set_product
        product_id = params[:product_id] || params[:id]
        @product = Product.find_by(id: product_id)
        unless @product
          render json: { success: false, message: "Product not found" }, status: :not_found
        end
      end
      
    end
  end