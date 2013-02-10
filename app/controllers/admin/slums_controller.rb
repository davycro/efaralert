class Admin::SlumsController < ApplicationController

  before_filter :require_admin_login

  layout 'admin'

  def index
    @slums = Slum.all
  end

  def new
    @slum = Slum.new
  end

  def edit
    @slum = Slum.find(params[:id])
  end

  def update
    @slum = Slum.find(params[:id])
    if @slum.update_attributes(params[:slum])
      redirect_to admin_slums_path, :notice => "Changes saved"
    else
      render :action => 'edit'
    end
  end

  def create
    @slum = Slum.new(params[:slum])
    if @slum.save
      redirect_to admin_slums_path, :notice => "Settlement created"
    else
      render :action => 'new'
    end
  end

  def destroy
    @slum = Slum.find(params[:id])
    @slum.destroy
    redirect_to admin_slums_path, :notice => "Record deleted"
  end
end
