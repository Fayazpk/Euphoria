module Usermodule
  class CheckoutsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_cart
    before_action :ensure_cart_not_empty
    before_action :load_addresses, only: %i[new create]
    

    def new
      Rails.logger.info "Initializing checkout for user: #{current_user.id}"
      @checkout = Checkout.new
      calculate_totals
    rescue StandardError => e
      handle_error('checkout initialization', e, usermodule_cart_path)
    end

    def create
      ActiveRecord::Base.transaction do
        calculate_totals
        @checkout = build_checkout
    
        if @checkout.save
          Rails.logger.info "Checkout saved successfully with ID: #{@checkout.id}"

          process_payment
          clear_cart
          redirect_to usermodule_cart_path, notice: 'Order placed successfully!'
          
        else
          Rails.logger.error "Checkout save failed: #{@checkout.errors.full_messages}"
          flash.now[:alert] = @checkout.errors.full_messages.to_sentence
          load_addresses
          render :new, status: :unprocessable_entity
        end
      end
    rescue StandardError => e
      Rails.logger.error "Checkout creation failed: #{e.message}\nBacktrace: #{e.backtrace[0..5].join("\n")}"
      flash.now[:alert] = 'An error occurred. Please try again.'
      load_addresses
      render :new, status: :unprocessable_entity
    end

    def apply_coupon
      calculate_totals
      @discount = calculate_coupon_discount(params[:coupon_code])

      if @discount.positive?
        Rails.logger.info "Coupon applied successfully: #{params[:coupon_code]}, Discount: #{@discount}"
        render json: { 
          discount: @discount,
          total: calculate_final_total,
          message: "Coupon applied successfully!"
        }
      else
        Rails.logger.error "Invalid Coupon Code: #{params[:coupon_code]}"
        render json: { 
          error: "Invalid coupon code",
          total: calculate_final_total 
        }, status: :unprocessable_entity
      end
    end

    private

    def clear_cart
      Rails.logger.info "Clearing cart for user: #{current_user.id}"
      @cart.orderables.destroy_all
    end

    def build_checkout
      checkout_attributes = {
        cart: @cart,
        user: current_user,
        address_id: checkout_params[:address_id],
        payment_method: checkout_params[:payment_method].to_s.downcase,
        total_price: calculate_final_total,
        status: 'pending',
        payment_status: 'pending'
      }

      Rails.logger.info "Building checkout with attributes: #{checkout_attributes.inspect}"
      Checkout.new(checkout_attributes)
    end

    def process_payment
      raise 'Invalid payment method' unless valid_payment_method?

      @checkout.update!(
        payment_status: 'pending',
        status: 'processing',
        transaction_id: generate_transaction_id
      )
    end

    def valid_payment_method?
      method = checkout_params[:payment_method].to_s.downcase
      Rails.logger.info "Validating payment method: #{method}"
      Checkout::PAYMENT_METHODS.include?(method)
    end

    def set_cart
      @cart = current_user.cart
      redirect_with_error('Cart not found', root_path) unless @cart
    end

    def ensure_cart_not_empty
      return unless @cart.orderables.empty?
      redirect_with_error('Your cart is empty', usermodule_cart_path)
    end

    def load_addresses
      @addresses = current_user.addresses
      if @addresses.empty?
        redirect_with_error(
          'Please add a delivery address to continue with checkout',
          new_usermodule_address_path
        )
      end
    end

    def calculate_totals
      return unless @cart

      @subtotal = @cart.orderables.sum { |orderable| calculate_orderable_price(orderable) }
      @tax = (@subtotal * 0.1).round(2)
      @shipping = 10.0
      @discount = calculate_coupon_discount(params[:coupon_code])
      @total = (@subtotal + @tax + @shipping - @discount).round(2)

      Rails.logger.debug "Totals calculated: Subtotal: #{@subtotal}, Tax: #{@tax}, Shipping: #{@shipping}, Discount: #{@discount}, Total: #{@total}"
    end

    def calculate_orderable_price(orderable)
      return 0 unless orderable.product

      product = orderable.product
      price = (product.base_price * (1 - product.discount_percentage / 100.0)).round(2)
      (price * orderable.quantity).round(2)
    end

    def calculate_coupon_discount(code)
      return 0 unless code.present?

      case code.upcase
      when 'SAVE10'
        (@subtotal * 0.10).round(2)
      when 'SAVE20'
        (@subtotal * 0.20).round(2)
      else
        0
      end
    end

    def calculate_final_total
      @total ||= 0  # Ensure @total is set
      @discount ||= 0  # Ensure @discount is set to 0 if it's nil
      
      # Now perform the calculation safely
      (@total - @discount).round(2)
    end

    def generate_transaction_id
      "TXN#{Time.current.to_i}#{SecureRandom.hex(4).upcase}"
    end

    def redirect_with_error(message, path)
      Rails.logger.error message
      redirect_to path, alert: message
    end

    def handle_error(action, error, path = nil, render_action: nil, status: nil, json: false)
      Rails.logger.error "Error during #{action}: #{error.message}"
      if json
        render json: { status: 'error', message: 'An error occurred' }, status: :unprocessable_entity
      elsif path
        redirect_to path, alert: 'An error occurred. Please try again.'
      else
        flash.now[:alert] = 'An error occurred. Please try again.'
        render render_action, status: status
      end
    end

    def checkout_params
      params.require(:checkout).permit(:address_id, :payment_method, :coupon_code)
    end
  end
end