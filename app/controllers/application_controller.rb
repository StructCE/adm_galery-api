class ApplicationController < ActionController::API
  def require_login
    head(:unauthorized) unless current_user.presence
  end

  def admin_permission
    head(:forbidden) unless current_user.presence && current_user.admin
  end
end
