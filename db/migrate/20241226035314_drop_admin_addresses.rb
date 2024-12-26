class DropAdminAddresses < ActiveRecord::Migration[8.0]
  def change
    drop_table :admin_addresses
  end
end
