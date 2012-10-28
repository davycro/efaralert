class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def require_admin_login
    unless current_admin
      redirect_to new_admin_session_url
    end
  end

  def current_admin
    @current_admin ||= Admin.find(session[:admin_id]) if session[:admin_id].present?
  end

  def require_researcher_login
    unless current_researcher
      redirect_to new_research_session_path
    end
  end

  def current_researcher
    @current_researcher ||= Researcher.find(session[:researcher_id]) if session[:researcher_id].present?
  end
end
