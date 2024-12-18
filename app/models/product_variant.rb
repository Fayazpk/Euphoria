class ProductVariant < ApplicationRecord
  belongs_to :product
  
  
  attribute :size, :integer
  enum :size, { s: 0, m: 1, l: 2, xl: 3 }

  validates :stock, numericality: { greater_than_or_equal_to: 0 }
  validates :size, presence: true, inclusion: { in: sizes.keys }

  def out_of_stock?
    stock <= 0
  end
end