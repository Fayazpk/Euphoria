class RenameWhishlistsToWishlists < ActiveRecord::Migration[8.0]
  def change
    rename_table :whishlists, :wishlists
  end
end
