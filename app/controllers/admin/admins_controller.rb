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
      redirect_to admin_admins_path, :notice => "New admin created"
    else
      render :action => 'new'
    end
  end

  def update
    @admin = Admin.find(params[:id])
    if @admin.update_attributes(params[:admin])
      redirect_to admin_admins_path, :notice => "Changes saved"
    else
      render :action => 'edit'
    end
  end

  def destroy
    @admin = Admin.find(params[:id])
    if @admin==@current_admin
      redirect_to admin_admins_path, :notice => "You cannot delete your own account"
    end
    @admin.destroy
    redirect_to admin_admins_path, :notice => "Admin destroyed"
  end


end
