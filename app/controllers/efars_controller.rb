class EfarsController < ApplicationController
	before_filter :require_manager_login
	layout 'main'

  def index
    @efars = Efar.all
  end

  def new
    @efar = Efar.new
  end

  def edit
    @efar = Efar.find params[:id]
  end

  def update
    @efar = Efar.find params[:id]
    @efar.update_attributes params[:efar]
    if @efar.save
      redirect_to efars_path, notice: "EFAR updated"
    else
      render action: 'edit'
    end
  end

  def create
    @efar = Efar.new params[:efar]
    @efar.community_center = @current_manager.community
    if @efar.save
      redirect_to efars_path, notice: "EFAR created"
    else
      render action: 'new'
    end
  end

  def destroy
    @efar = Efar.find params[:id]
    @efar.destroy
    redirect_to efars_path, notice: "EFAR removed"
  end

end
