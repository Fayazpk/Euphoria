class AddSizeToProductVariants < ActiveRecord::Migration[8.0]
  def change
    add_column :product_variants, :size, :integer
  end
end
