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

  # dispatcher
  def require_dispatcher_login
    unless (current_dispatcher and current_suburb)
      redirect_to new_session_path
    end
  end

  def current_dispatcher
    @current_dispatcher ||= Dispatcher.find(session[:dispatcher_id]) if session[:dispatcher_id].present?
  end
  
  def current_suburb
    @current_suburb ||= Suburb.find(session[:suburb_id]) if session[:suburb_id].present?
  end

end
