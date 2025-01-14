class Usermodule::WalletsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_wallet
    before_action :validate_amount, only: [:add_money]
  
    def show
        @transactions = @wallet.wallet_transactions
                              .includes(:checkout)
                              .order(created_at: :desc)
                              .page(params[:page])
                              .per(20)
      end
  
    def add_money
      amount = params[:amount].to_f
  
      if @wallet.add_money(amount, "Manual wallet top-up")
        redirect_to usermodule_wallet_path, 
                    notice: "Successfully added #{number_to_currency(amount)} to wallet"
      else
        redirect_to usermodule_wallet_path, 
                    alert: "Failed to add money: #{@wallet.errors.full_messages.join(', ')}"
      end
    rescue => e
      Rails.logger.error "Wallet top-up failed: #{e.message}"
      redirect_to usermodule_wallet_path, 
                  alert: "An error occurred while processing your request"
    end
  
    private
  
    def set_wallet
        @wallet = current_user.wallet
        
        unless @wallet
          @wallet = current_user.create_wallet(balance: 0.0)
        end
      rescue => e
        Rails.logger.error "Wallet initialization failed: #{e.message}"
        redirect_to root_path, alert: "Unable to access wallet. Please try again later."
      end
  
    def validate_amount
      amount = params[:amount].to_f
      
      if amount < Wallet::MINIMUM_TRANSACTION_AMOUNT
        redirect_to usermodule_wallet_path, 
                    alert: "Minimum amount is #{number_to_currency(Wallet::MINIMUM_TRANSACTION_AMOUNT)}"
        return
      end
  
      if amount > Wallet::MAXIMUM_TRANSACTION_AMOUNT
        redirect_to usermodule_wallet_path, 
                    alert: "Maximum amount is #{number_to_currency(Wallet::MAXIMUM_TRANSACTION_AMOUNT)}"
        return
      end
    end
  end
  