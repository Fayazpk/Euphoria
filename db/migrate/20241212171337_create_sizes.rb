class RemoveSizes < ActiveRecord::Migration[8.0]
  def up
    remove_reference :products, :size, foreign_key: true, if_exists: true
    drop_table :sizes, if_exists: true
  end

  def down
    create_table :sizes do |t|
      t.string :size
      t.float :base_price, null: false, default: 0.0
      t.float :final_price, null: false, default: 0.0

      t.timestamps
    end
  end
end
