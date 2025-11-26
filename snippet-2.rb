# ============================================================================
# CODE REVIEW SNIPPET 2: Ruby on Rails Controller
# DO NOT USE - Contains vulnerabilities!
# ============================================================================

class UsersController < ApplicationController
  before_action :authenticate_user!

  def update_profile
    @user = User.find(params[:id])
    
    if @user.update(user_params)
      redirect_to profile_path(@user), notice: 'Profile updated successfully.'
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:firstname, :lastname, :email, :bio)
  end
end
