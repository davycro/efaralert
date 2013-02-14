class Admin::TownshipsController < ApplicationController

  before_filter :require_admin_login

  layout 'admin'

  def index
    @townships = Township.all
  end

  def new
    @township = Township.new
  end

  def edit
    @township = Township.find(params[:id])
  end

  def update
    @township = Township.find(params[:id])
    if @township.update_attributes(params[:township])
      redirect_to admin_townships_path, :notice => "Changes saved"
    else
      render :action => 'edit'
    end
  end

  def create
    @township = Township.new(params[:township])
    if @township.save
      redirect_to admin_townships_path, :notice => "Settlement created"
    else
      render :action => 'new'
    end
  end

  def destroy
    @township = Township.find(params[:id])
    @township.destroy
    redirect_to admin_townships_path, :notice => "Record deleted"
  end
end
