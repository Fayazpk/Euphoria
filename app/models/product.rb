class Product < ApplicationRecord
  belongs_to :category
  belongs_to :subcategory
  has_many :discounts, dependent: :destroy
  has_many :orderables, dependent: :destroy
  has_many :carts, through: :orderables
  has_many :product_variants, dependent: :destroy
  has_many :wishlists
  has_many :wishlist_users, through: :wishlists, source: :user
  accepts_nested_attributes_for :product_variants, allow_destroy: true


  after_create :create_variant, if: -> { product_variants.nil? }
  has_many_attached :images

  validates :name, presence: { message: "is required" }
  validates :description, presence: { message: "is required" }
  validates :base_price, presence: { message: "is required" }, numericality: { greater_than_or_equal_to: 0 }
  validates :category, presence: { message: "must be selected" }
  validates :subcategory, presence: { message: "must be selected" }
  validates :images, presence: { message: "must have at least one image" }

  
  def final_price
    return base_price unless discount_percentage.present? && discount_percentage > 0
    base_price * (1 - discount_percentage / 100.0)
  end
  def create_variant
    variant = product_variants.create
    Size.all.each do |size|
      variant.product_variant_sizes.create(size: size, stock: 0)
    end
  end
end
