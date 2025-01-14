class RemoveLocationReferencesFromAddresses < ActiveRecord::Migration[8.0]
  def change
    remove_column :addresses, :country_id, :integer
  end
end