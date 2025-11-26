# ============================================================================
# CODE REVIEW SNIPPET 3: Ruby on Rails Controller
# DO NOT USE - Contains vulnerabilities!
# ============================================================================

class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      
      # Log the successful login
      Rails.logger.info "User login successful: #{params[:email]} from IP #{request.remote_ip} with password #{params[:password]}"
      
      redirect_to dashboard_path
    else
      flash[:error] = "Invalid email or password"
      render :new
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
