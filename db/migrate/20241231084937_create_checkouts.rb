class CreateCheckouts < ActiveRecord::Migration[8.0]
  def change
    create_table :checkouts do |t|
      t.references :cart, null: false, foreign_key: true
      t.references :address, null: false, foreign_key: true
      t.decimal :total_price
      t.string :applied_coupon
      t.string :status

      t.timestamps
    end
  end
end
