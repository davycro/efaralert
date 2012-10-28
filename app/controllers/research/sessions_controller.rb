class Research::SessionsController < ApplicationController

  layout 'full_screen_login'

  def new
  end

  def create
    researcher = Researcher.find_by_email(params[:email])
    if researcher && researcher.authenticate(params[:password])
      session[:researcher_id] = researcher.id
      redirect_to research_efars_path, :notice => "logged in!"
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    session[:researcher_id] = nil
    redirect_to new_research_session_path, :notice => "You are now logged out"
  end
end
