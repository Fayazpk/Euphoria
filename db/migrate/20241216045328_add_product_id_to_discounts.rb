class AddProductIdToDiscounts < ActiveRecord::Migration[8.0]
  def change
    add_column :discounts, :product_id, :integer
  end
end
