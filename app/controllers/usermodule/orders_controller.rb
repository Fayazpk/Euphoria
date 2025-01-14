module Usermodule
  class OrdersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_order, only: [:show, :update_address, :request_return]

    def index
    
    
      @orders = current_user.checkouts
                                      .order(created_at: :desc)
                                      .page(params[:page])
                                      .per(10)
      

    
      @selected_order = @orders.find_by(id: params[:selected_order]) || @orders.first
    end

    def show
  
      @order_items = @order.cart.orderables
    end

    def update_address
  
      if @order.status == "shipped"
        return redirect_to usermodule_orders_path(@order), alert: "Cannot modify shipped order"
      end

    
      if @order.address.update(address_params)
        redirect_to usermodule_orders_path(@order), notice: "Address updated successfully"
      else
        redirect_to usermodule_orders_path(@order), alert: "Failed to update address"
      end
    end
    
    def request_return
      if @order.can_return?
        @return_request = @order.build_return_request(
          user: current_user,
          status: 'pending',
          reason: params[:reason]
        )
        
        if @return_request.save
          redirect_to usermodule_orders_path, notice: 'Return request submitted successfully'
        else
          redirect_to usermodule_orders_path, alert: @return_request.errors.full_messages.join(', ')
        end
      else
        redirect_to usermodule_orders_path, alert: 'This order cannot be returned'
      end
    end
    private

  
    def set_order
      @order = current_user.checkouts.find_by(id: params[:id])
      redirect_to usermodule_orders_path, alert: "Order not found" if @order.nil?
    end

    def address_params
      params.require(:address).permit(:first_name, :last_name, :building_name,
                                      :street_address, :city_id, :state_id,
                                      :country_id, :phone)
    end
  end
end
