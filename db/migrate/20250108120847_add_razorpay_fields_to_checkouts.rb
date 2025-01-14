class AddRazorpayFieldsToCheckouts < ActiveRecord::Migration[8.0]
  def change
    add_column :checkouts, :razorpay_order_id, :string
    add_column :checkouts, :razorpay_payment_id, :string
    add_column :checkouts, :razorpay_signature, :string
    add_index :checkouts, :razorpay_order_id
    add_index :checkouts, :razorpay_payment_id
  end
end
