class DropOrders < ActiveRecord::Migration[7.0]
  def up
    drop_table :orders
  end

  def down
    create_table :orders do |t|
      t.string :order_number, null: false, index: { unique: true }
      t.references :user, null: false, foreign_key: true
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :phone_number, null: false
      t.text :address, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :payment_method, null: false
      t.string :payment_status, null: false
      t.string :status, null: false
      t.decimal :total_amount, precision: 10, scale: 2
      t.decimal :shipping_cost, precision: 10, scale: 2
      
      t.timestamps
    end
  end
end