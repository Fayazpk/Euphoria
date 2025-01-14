class CreateCoupons < ActiveRecord::Migration[8.0]
  def change
    create_table :coupons do |t|
      t.string :code
      t.decimal :discount
      t.date :valid_from
      t.date :valid_until
      t.integer :max_usage
      t.boolean :status, default: true

      t.timestamps
    end
  end
end