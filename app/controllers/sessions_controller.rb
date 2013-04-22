class SessionsController < ApplicationController

  layout 'full_screen_login'

  def new
  end

  def create
    @dispatcher = Dispatcher.find(params[:dispatcher][:id])
    @drainage = Suburb.find(params[:drainage][:id])
    if @dispatcher && @dispatcher.authenticate(params[:password].downcase)
      session[:dispatcher_id] = @dispatcher.id
      session[:suburb_id] = params[:drainage][:id]
      ActivityLog.log "Dispatcher #{@dispatcher.full_name} logged in"
      redirect_to root_path, :notice => "logged in!"
    else
      flash.now.alert = "Password Invalid"
      render "new"
    end
  end

  def destroy
    session[:dispatcher_id] = nil
    redirect_to new_session_path, :notice => "You are now logged out"
  end
end
