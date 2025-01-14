class CreateWalletTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :wallet_transactions do |t|
      t.references :wallet, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :transaction_type # credit/debit
      t.string :description
      t.references :checkout, foreign_key: true, null: true # for order-related transactions
      t.timestamps
    end
  end
end
