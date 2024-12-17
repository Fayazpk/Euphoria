class CreateAdminProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :admin_products do |t|
      t.string :name
      t.string :description
      t.references :category, null: false, foreign_key: true
      t.references :subcategory, null: false, foreign_key: true
      t.references :size,
       null: false, foreign_key: true

      t.timestamps
    end
  end
end
