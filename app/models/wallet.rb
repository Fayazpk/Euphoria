
class Wallet < ApplicationRecord
    belongs_to :user
    has_many :wallet_transactions, dependent: :destroy
  
    validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :user_id, presence: true, uniqueness: true
 
    MINIMUM_TRANSACTION_AMOUNT = 1.0
    MAXIMUM_TRANSACTION_AMOUNT = 10000.0
  
    def add_money(amount, description = "Money added to wallet")
      amount = amount.to_f
      
    
      validate_transaction_amount(amount)
      
      transaction do
        update!(balance: balance + amount)
        wallet_transactions.create!(
          amount: amount,
          transaction_type: 'credit',
          description: description,
          balance_after: balance,
          transaction_id: generate_transaction_id
        )
      end
      true
    rescue ActiveRecord::RecordInvalid => e
      errors.add(:base, e.message)
      false
    end
  
    def deduct_money(amount, checkout = nil, description = "Purchase payment")
      amount = amount.to_f
      
 
      validate_transaction_amount(amount)
      validate_sufficient_balance(amount)
      
      transaction do
        update!(balance: balance - amount)
        wallet_transactions.create!(
          amount: amount,
          transaction_type: 'debit',
          description: description,
          checkout: checkout,
          balance_after: balance,
          transaction_id: generate_transaction_id
        )
      end
      true
    rescue ActiveRecord::RecordInvalid => e
      errors.add(:base, e.message)
      false
    end
  
    def available_balance
      balance
    end
  
    private
  
    def validate_transaction_amount(amount)
      if amount < MINIMUM_TRANSACTION_AMOUNT
        raise ActiveRecord::RecordInvalid.new(
          "Transaction amount must be at least #{MINIMUM_TRANSACTION_AMOUNT}"
        )
      end
      
      if amount > MAXIMUM_TRANSACTION_AMOUNT
        raise ActiveRecord::RecordInvalid.new(
          "Transaction amount cannot exceed #{MAXIMUM_TRANSACTION_AMOUNT}"
        )
      end
    end
  
    def validate_sufficient_balance(amount)
      return if amount <= balance
      raise ActiveRecord::RecordInvalid.new("Insufficient balance")
    end
  
    def generate_transaction_id
      "WLT#{Time.current.to_i}#{SecureRandom.hex(4).upcase}"
    end
  end