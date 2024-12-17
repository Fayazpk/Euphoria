class CleanupProductPriceColumns < ActiveRecord::Migration[8.0]
  def up
    # First, ensure the base_price column exists and has proper type
    change_column :products, :base_price, :decimal, precision: 10, scale: 2, null: false, default: 0
    
    # Update discount_percentage to have proper constraints
    change_column :products, :discount_percentage, :decimal, precision: 5, scale: 2, default: 0
    
    # Remove redundant columns
    remove_column :products, :price if column_exists?(:products, :price)
    remove_column :products, :final_price if column_exists?(:products, :final_price)
    
    # Drop the redundant discounts table if it exists
    drop_table :discounts if table_exists?(:discounts)
  end

  def down
    # Revert changes if needed
    change_column :products, :base_price, :float
    change_column :products, :discount_percentage, :decimal
    
    add_column :products, :price, :decimal unless column_exists?(:products, :price)
    add_column :products, :final_price, :float unless column_exists?(:products, :final_price)
    
    unless table_exists?(:discounts)
      create_table :discounts do |t|
        t.references :product, null: false, foreign_key: true
        t.decimal :discount_percentage, precision: 5, scale: 2, default: 0
        t.timestamps
      end
    end
  end
end 