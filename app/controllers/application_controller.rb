class ApplicationController < ActionController::API
  def require_login
    head(:unauthorized) unless current_user.presence
  end
end
