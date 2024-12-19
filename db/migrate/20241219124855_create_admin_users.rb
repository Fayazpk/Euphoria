class CreateAdminUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :admin_users do |t|
      t.string :email
      t.string :password_digest
      t.boolean :is_blocked

      t.timestamps
    end
  end
end
