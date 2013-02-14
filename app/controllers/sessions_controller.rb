class SessionsController < ApplicationController

  layout 'full_screen_login'

  def new
  end

  def create
    dispatcher = Dispatcher.find_by_username(params[:username])
    if dispatcher && dispatcher.authenticate(params[:password])
      session[:dispatcher_id] = dispatcher.id
      redirect_to root_path, :notice => "logged in!"
    else
      flash.now.alert = "Invalid username or password"
      render "new"
    end
  end

  def destroy
    session[:dispatcher_id] = nil
    redirect_to new_session_path, :notice => "You are now logged out"
  end
end
