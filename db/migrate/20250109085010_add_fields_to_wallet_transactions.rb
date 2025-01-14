class AddFieldsToWalletTransactions < ActiveRecord::Migration[8.0]
  def change
    add_column :wallet_transactions, :balance_after, :decimal, precision: 10, scale: 2
    add_column :wallet_transactions, :transaction_id, :string
    add_index :wallet_transactions, :transaction_id, unique: true
  end
end
