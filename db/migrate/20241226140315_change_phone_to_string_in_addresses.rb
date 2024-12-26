class ChangePhoneToStringInAddresses < ActiveRecord::Migration[8.0]
  def change
    change_column :addresses, :phone, :string
  end
end
