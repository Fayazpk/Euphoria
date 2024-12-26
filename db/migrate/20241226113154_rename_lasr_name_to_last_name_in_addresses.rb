class RenameLasrNameToLastNameInAddresses < ActiveRecord::Migration[8.0]
  def change
    rename_column :addresses, :lasr_name, :last_name
  end
end
