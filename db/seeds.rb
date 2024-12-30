sizes = [ 'S', 'M', 'L', 'XL' ]
sizes.each do |size|
  Size.find_or_create_by!(size: size)
end

ProductVariant.find_each do |variant|
  Size.find_each do |size|
    stock_value = rand(1..10) # Replace this with your actual logic
    ProductVariantSize.find_or_create_by!(
      product_variant: variant,
      size: size,
      stock: stock_value
    )
  end
end
