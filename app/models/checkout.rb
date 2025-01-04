class Checkout < ApplicationRecord
  belongs_to :cart
  belongs_to :address
  belongs_to :user

  attr_accessor :coupon_code

  # Validations
  validates :payment_method, presence: true
  validates :total_price, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true
  validates :payment_status, presence: true
  validates :payment_method, inclusion: { in: %w[cod card], message: "is not a valid payment method" }
  validates :status, inclusion: { in: %w[pending processing shipped delivered cancelled] }
  validates :payment_status, inclusion: { in: %w[pending completed cancelled failed] }
  validate :cart_has_items, on: :create
  validate :address_belongs_to_user

  # Constants
  STATUSES = %w[pending processing shipped delivered cancelled]
  PAYMENT_STATUSES = %w[pending completed cancelled failed]
  PAYMENT_METHODS = %w[cod card]

  # Callbacks
  before_validation :normalize_payment_method
  before_save :calculate_total_price, if: :cart_present?
  after_create :process_checkout
  after_update :perform_action_on_status_change, if: :status_changed?

  private

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

    # Apply coupon discount if present
    if coupon_code.present?
      discount = case coupon_code
      when "SAVE20"
                  0.20
      else
                  0
      end
      subtotal *= (1 - discount)
    end

    # Add tax and shipping
    tax = subtotal * 0.10  # 10% tax
    shipping = 10.0        # Flat shipping rate

    self.total_price = subtotal + tax + shipping
  end

  def cart_present?
    cart.present?
  end

  def process_checkout
    return unless valid?

    ActiveRecord::Base.transaction do
      # Update checkout status and generate transaction ID
      self.status = "processing"
      self.transaction_id = generate_transaction_id
      save!

      # Create new empty cart for user without validation
      new_cart = Cart.new(user: user)
      new_cart.save(validate: false)  # Skip validations when creating new cart

      # Archive old cart or mark it as processed
      cart.update!(status: "processed") if cart.respond_to?(:status)
    end
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, "Failed to process checkout: #{e.message}")
    raise ActiveRecord::Rollback
  end

  def generate_transaction_id
    "TXN#{Time.current.to_i}#{SecureRandom.random_number(1000000)}"
  end

  def perform_action_on_status_change
    notify_user_of_shipping if status_changed? && status == "shipped"
  end

  def notify_user_of_shipping
    # Implement shipping notification logic here
  end
end
