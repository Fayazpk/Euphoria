class Checkout < ApplicationRecord
  belongs_to :cart
  belongs_to :address
  belongs_to :user
  has_one :return_request, dependent: :destroy
 

  attr_accessor :coupon_code

  PAYMENT_METHODS = %w[cod card razorpay wallet]
  PAYMENT_STATUSES = %w[pending completed cancelled failed processing]
  STATUSES = %w[pending processing shipped delivered cancelled]

  validates :payment_method, presence: true
  validates :total_price, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true
  validates :payment_status, presence: true
  validates :payment_method, inclusion: { in: PAYMENT_METHODS, message: "is not a valid payment method" }
  validates :status, inclusion: { in: STATUSES }
  validates :payment_status, inclusion: { in: PAYMENT_STATUSES }
  validate :cart_has_items, on: :create
  validate :address_belongs_to_user

  before_validation :normalize_payment_method
  before_save :calculate_total_price, if: :cart_present?
  after_create :process_checkout
  after_update :perform_action_on_status_change, if: :status_changed?

  def create_razorpay_order
    return unless payment_method == 'razorpay'
    
    begin
      order = Razorpay::Order.create(
        amount: (total_price * 100).to_i, 
        currency: 'INR',
        receipt: "checkout_#{id}",
        payment_capture: 1,
        notes: {
          checkout_id: id,
          user_id: user_id
        }
      )
      
      update(
        razorpay_order_id: order.id,
        payment_status: 'pending'
      )
      
      order
    rescue Razorpay::Error => e
      errors.add(:base, "Razorpay error: #{e.message}")
      Rails.logger.error "Razorpay order creation failed: #{e.message}"
      nil
    end
  end

  def verify_razorpay_payment(payment_params)
    return false unless payment_method == 'razorpay'
    return false if payment_params.values.any?(&:blank?)
  
    begin
      Rails.logger.info "Starting Razorpay payment verification"
      Rails.logger.info "Payment params: #{payment_params.inspect}"
  
      # Build the verification parameters
      payment_verification = {
        razorpay_order_id: payment_params['razorpay_order_id'],
        razorpay_payment_id: payment_params['razorpay_payment_id'],
        razorpay_signature: payment_params['razorpay_signature']
      }
  
      # Verify the payment signature
      if Razorpay::Utility.verify_payment_signature(payment_verification)
        Rails.logger.info "Payment signature verified successfully"
        
        ActiveRecord::Base.transaction do
          update!(
            payment_status: 'completed',
            status: 'processing',
            razorpay_payment_id: payment_params['razorpay_payment_id'],
            razorpay_signature: payment_params['razorpay_signature']
          )
          process_successful_payment
        end
        
        true
      else
        Rails.logger.error "Payment signature verification failed"
        errors.add(:base, "Invalid payment signature")
        false
      end
    rescue Razorpay::Error => e
      Rails.logger.error "Razorpay Error: #{e.message}"
      update(payment_status: 'failed')
      errors.add(:base, "Payment verification failed: #{e.message}")
      false
    rescue StandardError => e
      Rails.logger.error "Unexpected error during payment verification: #{e.message}\n#{e.backtrace.join("\n")}"
      update(payment_status: 'failed')
      errors.add(:base, "An unexpected error occurred during payment verification")
      false
    end
  end
  def can_return?
    status == 'delivered' && 
    delivered_at.present? && 
    delivered_at > 7.days.ago && 
    return_request.nil?
  end

  def apply_coupon(code)
    return false if code.blank?

    coupon = Coupon.find_by(code: code.upcase)
    
    if coupon.nil?
      errors.add(:coupon_code, "Invalid coupon code")
      return false
    end

    unless coupon.status
      errors.add(:coupon_code, "Coupon is inactive")
      return false
    end

    if coupon.valid_from && coupon.valid_from > Date.current
      errors.add(:coupon_code, "Coupon is not yet valid")
      return false
    end

    if coupon.valid_until && coupon.valid_until < Date.current
      errors.add(:coupon_code, "Coupon has expired")
      return false
    end

    # Check if maximum usage limit is reached
    if coupon.max_usage && Checkout.where(applied_coupon: code).count >= coupon.max_usage
      errors.add(:coupon_code, "Coupon usage limit reached")
      return false
    end

    self.coupon_code = code
    self.applied_coupon = code
    calculate_total_price
    save
  end
  private

   def validate_coupon
    return unless coupon_code.present?
    
    coupon = Coupon.find_by(code: coupon_code.upcase)
    return errors.add(:coupon_code, "Invalid coupon code") unless coupon
    
    errors.add(:coupon_code, "Coupon is inactive") unless coupon.status
    errors.add(:coupon_code, "Coupon has expired") if coupon.valid_until && coupon.valid_until < Date.current
    errors.add(:coupon_code, "Coupon is not yet valid") if coupon.valid_from && coupon.valid_from > Date.current
  end
  def process_successful_payment
    ActiveRecord::Base.transaction do
      # First update the checkout
      save!
      
      if cart.present?
        # Store the user reference before destroying cart contents
        user_ref = cart.user
        
        # Clear cart contents
        cart.orderables.destroy_all
        
        # Update cart status if applicable
        cart.update!(status: "processed") if cart.respond_to?(:status)
        
        # Create new cart for user if needed
        if user_ref.present? && user_ref.cart.nil?
          Cart.create!(user: user_ref)
        end
      end
    end
  end

  def process_checkout
    return unless valid?

    ActiveRecord::Base.transaction do
      if payment_method == 'razorpay'
        self.status = 'pending'
        self.payment_status = 'pending'
      else
        self.status = 'processing'
        self.payment_status = payment_method == 'cod' ? 'pending' : 'completed'
      end

      self.transaction_id = generate_transaction_id
      save!

      unless payment_method == 'razorpay'
        new_cart = Cart.new(user: user)
        new_cart.save(validate: false)
        cart.update!(status: "processed") if cart.respond_to?(:status)
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, "Failed to process checkout: #{e.message}")
    raise ActiveRecord::Rollback
  end

  def cart_has_items
    errors.add(:base, "Cart cannot be empty") if cart&.orderables&.empty?
  end

  def address_belongs_to_user
    return unless address_id
    unless cart&.user&.addresses&.exists?(address_id)
      errors.add(:address_id, "is not valid")
    end
  end

  def normalize_payment_method
    self.payment_method = payment_method.downcase if payment_method.present?
  end

  def calculate_total_price
    subtotal = cart.orderables.sum do |orderable|
      product = orderable.product
      discounted_price = product.base_price * (1 - (product.discount_percentage / 100.0))
      discounted_price * orderable.quantity
    end

    if coupon_code.present?
      if coupon = Coupon.find_by(code: coupon_code.upcase)
        discount_amount = (subtotal * coupon.discount / 100.0)
        subtotal -= discount_amount
      end
    end

    tax = subtotal * 0.10
    shipping = 10.0

    self.total_price = subtotal + tax + shipping
  end

  def cart_present?
    cart.present?
  end

  def generate_transaction_id
    "TXN#{Time.current.to_i}#{SecureRandom.random_number(1000000)}"
  end

  def perform_action_on_status_change
    notify_user_of_shipping if status_changed? && status == "shipped"
  end

  def notify_user_of_shipping
  end

end