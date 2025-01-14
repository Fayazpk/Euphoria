class WalletTransaction < ApplicationRecord
    belongs_to :wallet
    belongs_to :checkout, optional: true
  
    validates :amount, presence: true, numericality: true
    validates :transaction_type, presence: true, inclusion: { in: %w[credit debit] }
    validates :transaction_id, presence: true, uniqueness: true
    validates :balance_after, presence: true, numericality: true
  
    scope :credits, -> { where(transaction_type: 'credit') }
    scope :debits, -> { where(transaction_type: 'debit') }
  end