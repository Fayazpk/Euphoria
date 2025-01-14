class RenameAdminCouponsToCoupons < ActiveRecord::Migration[8.0]
  def change
    rename_table :admin_coupons, :coupons
  end
end
