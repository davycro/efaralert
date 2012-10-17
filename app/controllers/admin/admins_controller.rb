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
  end

  def update
  end

  def destroy
  end


end
