class Admin::AdminsController < ApplicationController
  layout 'efar_admin'

  before_filter :require_admin_login

  def index
    @admins = Admin.all
  end

  def edit
    @admin = Admin.find(params[:id])
  end

  def new
    @admin = Admin.new
  end

  def show
    @admin = Admin.find(params[:id])
  end

  def create
    @admin = Admin.new(params[:admin])
    if @admin.save
      redirect_to admin_admin_path(@admin), :notice => "New admin created"
    else
      render :action => 'new'
    end
  end

  def update
  end

  def destroy
  end


end
