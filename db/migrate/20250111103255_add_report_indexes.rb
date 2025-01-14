class AddReportIndexes < ActiveRecord::Migration[8.0]
  def change
    add_index :checkouts, :created_at
    add_index :checkouts, :payment_status
  end
end
