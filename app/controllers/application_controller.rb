class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  #
  # Login Methods

  def require_efar_login
    unless current_efar
      redirect_to new_session_url
    end
  end

  def current_efar
    false
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
