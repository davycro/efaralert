class Admin::DispatchersController < ApplicationController
  layout 'admin'

  before_filter :require_admin_login

  def index
    @dispatchers = Dispatcher.all
  end

  def edit
    @dispatcher = Dispatcher.find(params[:id])
  end

  def new
    @dispatcher = Dispatcher.new
  end

  def show
    @dispatcher = Dispatcher.find(params[:id])
  end

  def create
    @dispatcher = Dispatcher.new(params[:dispatcher])
    if @dispatcher.save
      redirect_to admin_dispatchers_path, :notice => "New dispatcher created"
    else
      render :action => 'new'
    end
  end

  def update
    @dispatcher = Dispatcher.find(params[:id])
    if @dispatcher.update_attributes(params[:dispatcher])
      redirect_to admin_dispatchers_path, :notice => "Changes saved"
    else
      render :action => 'edit'
    end
  end

  def destroy
    @dispatcher = Dispatcher.find(params[:id])
    @dispatcher.destroy
    redirect_to admin_dispatchers_path, :notice => "Dispatcher destroyed"
  end
end
