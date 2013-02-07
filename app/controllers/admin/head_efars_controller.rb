class Admin::HeadEfarsController < ApplicationController
  layout 'admin'

  before_filter :require_admin_login

  def index
    @head_efars = HeadEfar.all
  end

  def edit
    @head_efar = HeadEfar.find(params[:id])
  end

  def new
    @head_efar = HeadEfar.new
  end

  def show
    @head_efar = HeadEfar.find(params[:id])
  end

  def create
    @head_efar = HeadEfar.new(params[:head_efar])
    if @head_efar.save
      redirect_to admin_head_efars_path, :notice => "New head efar created"
    else
      render :action => 'new'
    end
  end

  def update
    @head_efar = HeadEfar.find(params[:id])
    if @head_efar.update_attributes(params[:head_efar])
      redirect_to admin_head_efars_path, :notice => "Changes saved"
    else
      render :action => 'edit'
    end
  end

  def destroy
    @head_efar = HeadEfar.find(params[:id])
    @head_efar.destroy
    redirect_to admin_head_efars_path, :notice => "Head Efar destroyed"
  end  
end
