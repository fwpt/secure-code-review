# ============================================================================
# CODE REVIEW SNIPPET 5: Ruby on Rails Controller
# DO NOT USE - Contains vulnerabilities!
# ============================================================================

class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_api_user!

  def transfer_funds
    amount = params[:amount].to_f
    recipient_id = params[:recipient_id]
    
    sender = current_user
    recipient = User.find(recipient_id)
    
    if sender.balance >= amount
      ActiveRecord::Base.transaction do
        sender.update!(balance: sender.balance - amount)
        recipient.update!(balance: recipient.balance + amount)
        
        Transfer.create!(
          sender_id: sender.id,
          recipient_id: recipient.id,
          amount: amount,
          status: 'completed'
        )
      end
      
      render json: { success: true, new_balance: sender.balance }
    else
      render json: { error: 'Insufficient funds' }, status: :unprocessable_entity
    end
  end
  
  private
  
  def authenticate_api_user!
    token = request.headers['Authorization']&.gsub('Bearer ', '')
    @current_user = User.find_by(api_token: token)
    
    unless @current_user
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
