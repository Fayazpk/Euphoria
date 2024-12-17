class CreateDiscountsTable < ActiveRecord::Migration[8.0]
  def change
    create_table :discounts do |t|
      t.references :product, null: false, foreign_key: true
      t.decimal :discount_percentage, precision: 5, scale: 2, default: 0

      t.timestamps
    end
  end
end 