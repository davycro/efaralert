class Admin::EfarsController < ApplicationController
  layout 'efar_admin'

  before_filter :require_admin_login

  def index
    params[:page] ||= 0
    @page = params[:page].to_i
    @efars = Efar.all_for_page(@page)
  end

  def edit
    @efar = Efar.find(params[:id])
  end

  def new
    @efar = Efar.new
  end

  def show
    @efar = Efar.find(params[:id])
  end

  def create
    @efar = Efar.new(params[:efar])
    if @efar.save
      redirect_to admin_efars_path, :notice => "New efar created"
    else
      render :action => 'new'
    end
  end

  def update
    @efar = Efar.find(params[:id])
    if @efar.update_attributes(params[:efar])
      redirect_to admin_efars_path, :notice => "Changes saved"
    else
      render :action => 'edit'
    end
  end

  def destroy
    @efar = Efar.find(params[:id])
    @efar.destroy
    redirect_to admin_efars_path, :notice => "Efar destroyed"
  end
end