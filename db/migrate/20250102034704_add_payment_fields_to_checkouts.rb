class AddPaymentFieldsToCheckouts < ActiveRecord::Migration[8.0]
  def change
    add_column :checkouts, :payment_method, :string
    add_column :checkouts, :payment_status, :string, default: 'pending'
    add_column :checkouts, :transaction_id, :string
  end
end