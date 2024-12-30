class ProductVariantSize < ApplicationRecord
  belongs_to :product_variant
  belongs_to :size
end
