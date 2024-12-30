class CreateProductVariantSizes < ActiveRecord::Migration[8.0]
  def change
    create_table :product_variant_sizes do |t|
      t.references :product_variant, null: false, foreign_key: true
      t.references :size, null: false, foreign_key: true
      t.integer :stock

      t.timestamps
    end
  end
end
