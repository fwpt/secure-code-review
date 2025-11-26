# ============================================================================
# CODE REVIEW SNIPPET 4: Ruby on Rails Controller
# DO NOT USE - Contains vulnerabilities!
# ============================================================================

class DocumentsController < ApplicationController
  before_action :authenticate_user!

  def download
    filename = params[:file]
    filepath = Rails.root.join('public', 'documents', filename)
    
    if File.exist?(filepath)
      send_file filepath, disposition: 'attachment'
    else
      render plain: "File not found", status: :not_found
    end
  end
  
  def show_image
    image_path = params[:path]
    full_path = "/var/www/app/uploads/#{image_path}"
    
    if File.exist?(full_path)
      send_file full_path, type: 'image/jpeg', disposition: 'inline'
    else
      render plain: "Image not found", status: :not_found
    end
  end
end
