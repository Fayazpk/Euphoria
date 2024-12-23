class AddOAuthFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    unless column_exists?(:users, :provider)
      add_column :users, :provider, :string
    end

    unless column_exists?(:users, :uid)
      add_column :users, :uid, :string
    end

    unless column_exists?(:users, :otp_code)
      add_column :users, :otp_code, :string
    end

    unless column_exists?(:users, :otp_expires_at)
      add_column :users, :otp_expires_at, :datetime
    end

    add_index :users, [ :provider, :uid ], unique: true, if_not_exists: true
  end
end
