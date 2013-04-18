class Admin::EfarsController < ApplicationController
  layout 'admin'

  before_filter :require_admin_login

  def index
    @efars = Efar.order('id DESC').all
  end

  def map
    respond_to do |format|
      format.json do 
        @efars = Efar.has_geolocation.all
        render json: @efars.to_json
      end
      format.html
    end 
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
      redirect_to admin_efar_path(@efar), :notice => "Changes saved"
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
