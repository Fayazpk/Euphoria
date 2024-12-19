class Product < ApplicationRecord
  belongs_to :category
  belongs_to :subcategory
  has_many :product_variants, dependent: :destroy
  accepts_nested_attributes_for :product_variants, allow_destroy: true, reject_if: :all_blank

  has_many_attached :images

  # Validations
  validates :name, presence: true
  validates :description, presence: true
  validates :base_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Method to calculate final price (but not store it)
  def final_price
    return base_price unless discount_percentage.present? && discount_percentage > 0
    base_price * (1 - discount_percentage / 100.0)
  end
end
