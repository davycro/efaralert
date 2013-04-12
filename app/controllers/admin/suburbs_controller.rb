class Admin::SuburbsController < ApplicationController

  layout 'admin'

  before_filter :require_admin_login


  def new
    @suburb = Suburb.new
  end

  def index
    @suburbs = Suburb.all()
  end

  def edit
    @suburb = Suburb.find(params[:id])
  end

  def create
    @suburb = Suburb.new(params[:suburb])
    if @suburb.save
      redirect_to admin_suburbs_path, :notice => "New suburb created"
    else
      render :action => 'new'
    end
  end

  def update
    @suburb = Suburb.find(params[:id])
    if @suburb.update_attributes(params[:suburb])
      redirect_to admin_suburbs_path, :notice => "Changes saved"
    else
      render :action => 'edit'
    end
  end

  def destroy
    @suburb = Suburb.find(params[:id])
    @suburb.destroy
    redirect_to admin_suburbs_path, :notice => "Suburb destroyed"
  end
end
