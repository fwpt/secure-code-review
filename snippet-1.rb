# ============================================================================
# VULNERABLE CODE REVIEW SNIPPET 1: Ruby on Rails Controller
# DO NOT USE - Contains vulnerabilities!
# ============================================================================

class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def search
    @query = params[:search]
    
    if @query.present?
      @projects = Project.where("name LIKE '%#{@query}%' AND user_id = #{current_user.id}")
    else
      @projects = Project.where(user_id: current_user.id)
    end
    
    render json: @projects
  end
end
