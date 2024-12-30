class Cart < ApplicationRecord
  belongs_to :user
  has_many :orderables, dependent: :destroy
  has_many :products, through: :orderables

  # Add a method to fetch items (products) from the cart
  def items
    self.products
  end
end
