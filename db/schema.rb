# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_01_14_095232) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "building_name"
    t.string "street_address"
    t.string "phone"
    t.bigint "city_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "state_id"
    t.bigint "country_id"
    t.index ["city_id"], name: "index_addresses_on_city_id"
    t.index ["country_id"], name: "index_addresses_on_country_id"
    t.index ["state_id"], name: "index_addresses_on_state_id"
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "admin_products", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.bigint "category_id", null: false
    t.bigint "subcategory_id", null: false
    t.bigint "size_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_admin_products_on_category_id"
    t.index ["size_id"], name: "index_admin_products_on_size_id"
    t.index ["subcategory_id"], name: "index_admin_products_on_subcategory_id"
  end

  create_table "admin_subcategories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_admin_subcategories_on_category_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.boolean "is_blocked"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "checkouts", force: :cascade do |t|
    t.bigint "cart_id", null: false
    t.bigint "address_id", null: false
    t.decimal "total_price"
    t.string "applied_coupon"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "payment_method"
    t.string "payment_status", default: "pending"
    t.string "transaction_id"
    t.bigint "user_id", null: false
    t.string "razorpay_order_id"
    t.string "razorpay_payment_id"
    t.string "razorpay_signature"
    t.datetime "delivered_at"
    t.index ["address_id"], name: "index_checkouts_on_address_id"
    t.index ["cart_id"], name: "index_checkouts_on_cart_id"
    t.index ["created_at"], name: "index_checkouts_on_created_at"
    t.index ["payment_status"], name: "index_checkouts_on_payment_status"
    t.index ["razorpay_order_id"], name: "index_checkouts_on_razorpay_order_id"
    t.index ["razorpay_payment_id"], name: "index_checkouts_on_razorpay_payment_id"
    t.index ["user_id"], name: "index_checkouts_on_user_id"
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.integer "pincode"
    t.bigint "state_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["state_id"], name: "index_cities_on_state_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "coupons", force: :cascade do |t|
    t.string "code"
    t.decimal "discount"
    t.text "description"
    t.date "valid_from"
    t.date "valid_until"
    t.integer "max_usage"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "discounts", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.decimal "discount_percentage", precision: 5, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_discounts_on_product_id"
  end

  create_table "orderables", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "product_variant_id", null: false
    t.bigint "cart_id", null: false
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "size"
    t.index ["cart_id"], name: "index_orderables_on_cart_id"
    t.index ["product_id"], name: "index_orderables_on_product_id"
    t.index ["product_variant_id"], name: "index_orderables_on_product_variant_id"
  end

  create_table "payments", force: :cascade do |t|
    t.string "razorpay_payment_id"
    t.decimal "amount"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_variant_sizes", force: :cascade do |t|
    t.bigint "product_variant_id", null: false
    t.bigint "size_id", null: false
    t.integer "stock"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_variant_id"], name: "index_product_variant_sizes_on_product_variant_id"
    t.index ["size_id"], name: "index_product_variant_sizes_on_size_id"
  end

  create_table "product_variants", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.integer "stock"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_variants_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "category_id", null: false
    t.bigint "subcategory_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "base_price", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "discount_percentage", precision: 5, scale: 2, default: "0.0"
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["subcategory_id"], name: "index_products_on_subcategory_id"
  end

  create_table "return_requests", force: :cascade do |t|
    t.bigint "checkout_id", null: false
    t.bigint "user_id", null: false
    t.string "reason"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["checkout_id"], name: "index_return_requests_on_checkout_id"
    t.index ["user_id"], name: "index_return_requests_on_user_id"
  end

  create_table "sizes", force: :cascade do |t|
    t.string "size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "states", force: :cascade do |t|
    t.string "name"
    t.bigint "country_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_states_on_country_id"
  end

  create_table "subcategories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_subcategories_on_category_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin"
    t.string "otp_code"
    t.datetime "otp_expires_at"
    t.boolean "is_blocked", default: false
    t.boolean "verified", default: false
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
  end

  create_table "wallet_transactions", force: :cascade do |t|
    t.bigint "wallet_id", null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.string "transaction_type"
    t.string "description"
    t.bigint "checkout_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "balance_after", precision: 10, scale: 2
    t.string "transaction_id"
    t.index ["checkout_id"], name: "index_wallet_transactions_on_checkout_id"
    t.index ["transaction_id"], name: "index_wallet_transactions_on_transaction_id", unique: true
    t.index ["wallet_id"], name: "index_wallet_transactions_on_wallet_id"
  end

  create_table "wallets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.decimal "balance", precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_wallets_on_user_id"
  end

  create_table "wishlists", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_wishlists_on_product_id"
    t.index ["user_id"], name: "index_wishlists_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "addresses", "cities"
  add_foreign_key "addresses", "countries"
  add_foreign_key "addresses", "states"
  add_foreign_key "addresses", "users"
  add_foreign_key "admin_products", "categories"
  add_foreign_key "admin_products", "sizes"
  add_foreign_key "admin_products", "subcategories"
  add_foreign_key "admin_subcategories", "categories"
  add_foreign_key "carts", "users"
  add_foreign_key "checkouts", "addresses"
  add_foreign_key "checkouts", "carts"
  add_foreign_key "checkouts", "users"
  add_foreign_key "cities", "states"
  add_foreign_key "discounts", "products"
  add_foreign_key "orderables", "carts"
  add_foreign_key "orderables", "product_variants"
  add_foreign_key "orderables", "products"
  add_foreign_key "product_variant_sizes", "product_variants"
  add_foreign_key "product_variant_sizes", "sizes"
  add_foreign_key "product_variants", "products"
  add_foreign_key "products", "categories"
  add_foreign_key "products", "subcategories"
  add_foreign_key "return_requests", "checkouts"
  add_foreign_key "return_requests", "users"
  add_foreign_key "states", "countries"
  add_foreign_key "subcategories", "categories"
  add_foreign_key "wallet_transactions", "checkouts"
  add_foreign_key "wallet_transactions", "wallets"
  add_foreign_key "wallets", "users"
  add_foreign_key "wishlists", "products"
  add_foreign_key "wishlists", "users"
end
