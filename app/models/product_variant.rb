class ProductVariant < ApplicationRecord
  belongs_to :product
  has_many :product_variant_sizes, dependent: :destroy
  has_many :orderables
  has_many :sizes, through: :product_variant_sizes
  accepts_nested_attributes_for :product_variant_sizes, allow_destroy: true

  # Get stock for a specific size
  def stock_for_size(size)
    size_string = size.to_s.strip.upcase

    # Find the size record first
    size_record = Size.find_by("UPPER(size) = ?", size_string)
    return 0 unless size_record

    # Find the variant size record
    variant_size = product_variant_sizes.find_by(size_id: size_record.id)
    variant_size&.stock || 0
  end

  # Check if a size is out of stock
  def out_of_stock?(size)
    stock_for_size(size) <= 0
  end

  # Helper method for debugging
  def debug_size_info(size)
    size_record = Size.find_by("UPPER(size) = ?", size.to_s.strip.upcase)
    variant_size = size_record ? product_variant_sizes.find_by(size_id: size_record.id) : nil

    {
      input_size: size,
      size_record: size_record&.attributes,
      variant_size: variant_size&.attributes,
      stock: variant_size&.stock
    }
  end
end
