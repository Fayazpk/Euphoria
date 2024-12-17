class CreateSizes < ActiveRecord::Migration[8.0]
  def change
    create_table :sizes do |t|
      t.string :size
      t.float :base_price, null: false, default: 0.0
      t.float :final_price, null: false, default: 0.0

      t.timestamps
    end
  end
end
