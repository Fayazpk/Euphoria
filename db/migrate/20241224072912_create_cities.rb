class CreateCities < ActiveRecord::Migration[8.0]
  def change
    create_table :cities do |t|
      t.string :name
      t.integer :pincode
      t.references :state, null: false, foreign_key: true

      t.timestamps
    end
  end
end
