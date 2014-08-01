class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  #
  # Login Methods

  def require_manager_login
    unless current_manager
      redirect_to new_session_url
    end
  end

  def current_manager
    @current_manager ||= Manager.find(session[:manager_id]) if session[:manager_id].present?
  end

  # admin
  def require_admin_login
    unless current_admin
      redirect_to new_admin_session_url
    end
  end

  def current_admin
    @current_admin ||= Admin.find(session[:admin_id]) if session[:admin_id].present?
  end

end
