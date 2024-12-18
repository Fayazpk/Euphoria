class RemoveSizeFromProducts < ActiveRecord::Migration[7.0]
  def up
    # First remove the foreign key if it exists
    remove_foreign_key :products, :sizes if foreign_key_exists?(:products, :sizes)
    
    # Then remove the column
    remove_column :products, :size_id
  end

  def down
    add_reference :products, :size, foreign_key: true
  end
end