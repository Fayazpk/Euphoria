module Usermodule
  class CheckoutsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_cart
    before_action :ensure_cart_not_empty, except: [:razorpay_callback]
    before_action :load_addresses, only: [:new, :create]
    before_action :set_checkout, only: [:razorpay_callback, :show]

    def new
      Rails.logger.info "Initializing checkout for user: #{current_user.id}"
      @checkout = Checkout.new(cart: @cart, user: current_user)
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

          case @checkout.payment_method
          when 'razorpay'
            handle_razorpay_payment
          when 'wallet'
            handle_wallet_payment
          else
            handle_cod_payment
          end
        else
          handle_failed_checkout
        end
      rescue StandardError => e
        handle_checkout_error(e)
      end
    end

    def show
      @order = current_user.checkouts.find(params[:id])
      @checkout = current_user.checkouts.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      redirect_with_error('Checkout not found', usermodule_cart_path)
    end

    def razorpay_callback
      Rails.logger.info "Received Razorpay callback for checkout: #{@checkout.id}"
      
      begin
        # Extract payment data from the nested params
        payment_data = {
          'razorpay_payment_id' => params.dig(:checkout, :razorpay_payment_id),
          'razorpay_order_id' => params.dig(:checkout, :razorpay_order_id),
          'razorpay_signature' => params.dig(:checkout, :razorpay_signature)
        }
    
        Rails.logger.debug("Received Razorpay callback params: #{payment_data.inspect}")
    
        if payment_data.values.any?(&:blank?)
          missing = payment_data.select { |k, v| v.blank? }.keys
          Rails.logger.error "Missing Razorpay parameters: #{missing.join(', ')}"
          return render json: { 
            success: false, 
            error: "Missing required parameters: #{missing.join(', ')}" 
          }, status: :unprocessable_entity
        end
    
        if @checkout.verify_razorpay_payment(payment_data)
          Rails.logger.info "Payment verification successful for checkout: #{@checkout.id}"
          clear_cart
          render json: {
            success: true,
            message: "Payment successful",
            redirect_url: usermodule_order_path(@checkout)
          }
        else
          Rails.logger.error "Payment verification failed for checkout: #{@checkout.id}"
          render json: {
            success: false,
            error: "Payment verification failed",
            messages: @checkout.errors.full_messages
          }, status: :unprocessable_entity
        end
      rescue => e
        Rails.logger.error "Razorpay callback error: #{e.class} - #{e.message}\n#{e.backtrace.join("\n")}"
        render json: {
          success: false,
          error: "Payment processing failed. Please contact support."
        }, status: :internal_server_error
      end
    end

    private

    def razorpay_params
      params.permit(
        :razorpay_payment_id,
        :razorpay_order_id,
        :razorpay_signature,
        checkout: [:razorpay_payment_id, :razorpay_order_id, :razorpay_signature]
      )
    end

    def set_cart
      @cart = current_user.cart
      redirect_with_error('Cart not found', root_path) unless @cart
    end

    def set_checkout
      @checkout = current_user.checkouts.find_by(id: params[:id])
      render_error("Checkout not found", :not_found) unless @checkout
    end

    def ensure_cart_not_empty
      redirect_with_error('Your cart is empty', usermodule_cart_path) if @cart.orderables.empty?
    end

    def load_addresses
      @addresses = current_user.addresses
      redirect_with_error('Please add a delivery address to continue with checkout', new_usermodule_address_path) if @addresses.empty?
    end

    def handle_razorpay_payment
      order = @checkout.create_razorpay_order
      if order
        render json: {
          checkout_id: @checkout.id,
          razorpay_order_id: order.id,
          amount: order.amount,
          currency: order.currency
        }
      else
        render json: { error: @checkout.errors.full_messages.join(', ') }, status: :unprocessable_entity
      end
    end

    def handle_cod_payment
      process_payment
      clear_cart
      redirect_to usermodule_order_path(@checkout), notice: 'Order placed successfully!'
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
      Checkout::PAYMENT_METHODS.include?(checkout_params[:payment_method].to_s.downcase)
    end

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
      @total ||= 0
      @discount ||= 0
      (@total - @discount).round(2)
    end

    def handle_failed_checkout
      Rails.logger.error "Checkout save failed: #{@checkout.errors.full_messages}"
      flash.now[:alert] = @checkout.errors.full_messages.to_sentence
      load_addresses
      render :new, status: :unprocessable_entity
    end

    def handle_checkout_error(error)
      Rails.logger.error "Checkout creation failed: #{error.message}\nBacktrace: #{error.backtrace[0..5].join("\n")}"
      flash.now[:alert] = 'An error occurred. Please try again.'
      load_addresses
      render :new, status: :unprocessable_entity
    end

    def handle_error(type, error, path)
      Rails.logger.error "#{type} failed: #{error.message}"
      redirect_to path, alert: 'An error occurred. Please try again.'
    end

    def redirect_with_error(message, path)
      Rails.logger.error message
      redirect_to path, alert: message
    end

    def render_error(message, status = :unprocessable_entity)
      render json: { success: false, error: message }, status: status
    end

    def checkout_params
      params.require(:checkout).permit(:address_id, :payment_method, :coupon_code)
    end

    def generate_transaction_id
      "TXN#{Time.current.to_i}#{SecureRandom.hex(4).upcase}"
    end
  end
end