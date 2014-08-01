class EfarsController < ApplicationController
	before_filter :require_manager_login
	layout 'main'

  def index
    @efars = Efar.all
  end

  def new
    @efar = Efar.new
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

end
