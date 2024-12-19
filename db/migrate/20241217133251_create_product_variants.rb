class CreateProductVariants < ActiveRecord::Migration[7.0]
  def change
    create_table :product_variants do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :size, null: false
      t.integer :stock, null: false, default: 0

      t.timestamps
    end

    # Add an index for better query performance
    add_index :product_variants, [:product_id, :size], unique: true
  end
end
