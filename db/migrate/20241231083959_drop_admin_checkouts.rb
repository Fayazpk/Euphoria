class DropAdminCheckouts < ActiveRecord::Migration[8.0]
  def change
    drop_table :admin_checkouts, if_exists: true
  end
end
