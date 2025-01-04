module Usermodule
  class OrdersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_order, only: [ :show, :update_address ]

    def index
      # Eager load address and related associations (city, state, country)
      @orders = current_user.checkouts.includes(address: [ :city, :state, :country ])
                                      .order(created_at: :desc)
                                      .page(params[:page])
                                      .per(10)

      # Avoid extra query by checking if selected_order exists in the loaded @orders collection
      @selected_order = @orders.find_by(id: params[:selected_order]) || @orders.first
    end

    def show
      # Eager load orderables with products and product variants
      @order_items = @order.cart.orderables.includes(:product, :product_variant)
    end

    def update_address
      # Prevent modification if the order status is 'shipped'
      if @order.status == "shipped"
        return redirect_to usermodule_orders_path(@order), alert: "Cannot modify shipped order"
      end

      # Attempt to update the address and handle the result
      if @order.address.update(address_params)
        redirect_to usermodule_orders_path(@order), notice: "Address updated successfully"
      else
        redirect_to usermodule_orders_path(@order), alert: "Failed to update address"
      end
    end

    private

    # Use find_by to prevent exceptions if order is not found
    def set_order
      @order = current_user.checkouts.find_by(id: params[:id])
      redirect_to usermodule_orders_path, alert: "Order not found" if @order.nil?
    end

    def address_params
      # Permit only necessary parameters for address update
      params.require(:address).permit(:first_name, :last_name, :building_name,
                                      :street_address, :city_id, :state_id,
                                      :country_id, :phone)
    end
  end
end
