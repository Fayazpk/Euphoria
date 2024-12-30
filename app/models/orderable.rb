class Orderable < ApplicationRecord
  belongs_to :product
  belongs_to :product_variant
  belongs_to :cart

  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def total
    product.final_price * quantity
  end
end
