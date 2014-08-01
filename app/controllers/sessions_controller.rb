class SessionsController < ApplicationController
  layout 'full_screen_login'

  def new
  end

  def create
    manager = Manager.find_by_username params[:username]
    if manager && manager.authenticate(params[:password])
      session[:manager_id] = manager.id
      redirect_to efars_url
    else
      flash.now.alert = "Invalid password"
      render 'new'
    end
  end

  def destroy
    session[:manager_id] = nil
    redirect_to new_session_path, :notice => "Logged out"
  end
end
