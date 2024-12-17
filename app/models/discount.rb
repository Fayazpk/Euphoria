class Discount < ApplicationRecord
  belongs_to :product

  validates :discount_percentage, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100
  }
end
