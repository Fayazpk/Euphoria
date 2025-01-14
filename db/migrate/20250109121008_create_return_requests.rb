class CreateReturnRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :return_requests do |t|
      t.references :checkout, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :reason
      t.string :status

      t.timestamps
    end
    add_column :checkouts, :delivered_at, :datetime
  end
end
