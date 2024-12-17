class AddBasepriceAndFinalpriceToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :base_price, :float
    add_column :products, :final_price, :float
  end
end
