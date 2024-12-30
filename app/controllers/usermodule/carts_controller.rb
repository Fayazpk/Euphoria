class Usermodule::CartsController < ApplicationController
  before_action :set_cart

  def show
    Rails.logger.info "Fetching cart for user ##{current_user.id}"
    @cart = current_user.cart
    if @cart
      @cart_items = @cart.orderables || []
      Rails.logger.debug "Cart items: #{@cart_items.inspect}"
    else
      render_error("Cart not found", :not_found)
    end
  end

  def add_to_cart
    Rails.logger.info "add_to_cart called with params: #{params.inspect}"

    @product = Product.find_by(id: params[:product_id])
    return render_error("Product not found", :unprocessable_entity) unless @product

    @variant = ProductVariant.find_by(id: params[:variant_id])
    return render_error("Variant not found", :unprocessable_entity) unless @variant

    size_record = find_size(params[:size])
    return render_error("Invalid size", :unprocessable_entity) unless size_record

    variant_size = ProductVariantSize.lock.find_by(product_variant_id: @variant.id, size_id: size_record.id)
    return render_error("Size not available for this variant", :unprocessable_entity) unless variant_size

    if variant_size.stock.nil? || variant_size.stock <= 0
      return render_error("Out of stock", :unprocessable_entity)
    end

    quantity = [ params[:quantity].to_i, 1 ].max
    return render_error("Requested quantity not available", :unprocessable_entity) if variant_size.stock < quantity

    ActiveRecord::Base.transaction do
      orderable = @cart.orderables.find_or_initialize_by(
        product_id: @product.id,
        product_variant_id: @variant.id,
        size: size_record.size
      )
      orderable.quantity ||= 0
      orderable.quantity += quantity

      if orderable.save
        variant_size.update!(stock: variant_size.stock - quantity)
        render json: {
          success: true,
          message: "Added to cart successfully",
          cart_count: @cart.orderables.sum(:quantity)
        }
      else
        raise ActiveRecord::Rollback
      end
    end
  rescue StandardError => e
    Rails.logger.error "Error processing cart addition: #{e.message}"
    render json: { success: false, message: "An error occurred while processing your request" }, status: :unprocessable_entity
  end

  def destroy
    orderable = @cart.orderables.find_by(id: params[:id])
    if orderable&.destroy
      redirect_to usermodule_cart_path, notice: "Item was successfully deleted."
    else
      redirect_to usermodule_cart_path, alert: "Failed to delete item."
    end
  end

  private

  def set_cart
    Rails.logger.info "Setting cart for user ##{current_user.id}"
    @cart = current_user.cart || current_user.create_cart
    Rails.logger.debug "Cart set: #{@cart.inspect}"
  end

  def cart_params
    params.permit(:product_id, :variant_id, :size, :quantity)
  end

  def find_size(size_param)
    sizes_to_try = [ size_param, size_param.downcase, size_param.upcase ].compact
    Rails.logger.debug "Trying sizes: #{sizes_to_try.inspect}"
    Size.where(size: sizes_to_try).first
  end

  def render_error(message, status)
    Rails.logger.error message
    render json: { success: false, message: message }, status: status
  end
end
