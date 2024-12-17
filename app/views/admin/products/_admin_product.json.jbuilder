json.extract! admin_product, :id, :name, :description, :category_id, :subcategory_id, :size_id, :created_at, :updated_at
json.url admin_product_url(admin_product, format: :json)

json.size do
  json.extract! admin_product.size, :id, :size
end
