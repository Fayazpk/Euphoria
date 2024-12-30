class UpdateProductVariantsWithFixedSizes < ActiveRecord::Migration[8.0]
  def change
    remove_column :product_variants, :size
    
    # Add fixed size columns with stock
    add_column :product_variants, :s_stock, :integer, default: 0
    add_column :product_variants, :m_stock, :integer, default: 0
    add_column :product_variants, :l_stock, :integer, default: 0
    add_column :product_variants, :xl_stock, :integer, default: 0
  end
end
