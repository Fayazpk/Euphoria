json.extract! admin_coupon, :id, :code, :discount, :description, :valid_from, :valid_until, :max_usage, :status, :created_at, :updated_at
json.url admin_coupon_url(admin_coupon, format: :json)
