class RemoveUnusedColumnsFromProductVariants < ActiveRecord::Migration[8.0]
  def change
    remove_column :product_variants, :variant_name, :string
    remove_column :product_variants, :s_stock, :integer
    remove_column :product_variants, :m_stock, :integer
    remove_column :product_variants, :l_stock, :integer
    remove_column :product_variants, :xl_stock, :integer
  end
end
