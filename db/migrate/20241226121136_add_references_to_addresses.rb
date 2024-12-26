class AddReferencesToAddresses < ActiveRecord::Migration[8.0]
  def change
    add_reference :addresses, :country, foreign_key: true
    add_reference :addresses, :state, foreign_key: true
  end
end
