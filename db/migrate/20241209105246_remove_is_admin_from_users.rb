class RemoveIsAdminFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :is_admin, :boolean
  end
end
