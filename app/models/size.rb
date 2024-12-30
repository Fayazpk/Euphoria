class Size < ApplicationRecord
  has_many :product_variant_sizes
  has_many :product_variants, through: :product_variant_sizes
end
