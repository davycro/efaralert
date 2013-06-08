class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  #
  # Login Methods

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
