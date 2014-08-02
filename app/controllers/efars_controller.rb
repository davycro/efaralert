class EfarsController < ApplicationController
	before_filter :require_manager_login
	layout 'main'

  def index
    @efars = @current_manager.efars.order('id DESC').all
  end

  def active
    @efars = @current_manager.efars.active.order('id DESC').all
    @efars.delete_if { |e| e.not_competent? }
    render action: 'index'
  end

  def bibbed
    @efars = @current_manager.efars.has_bib.order('id DESC').all
    render action: 'index'
  end

  def nyc
    @efars = @current_manager.efars.order('id DESC').all
    @efars.delete_if { |e| !e.not_competent? }
    render action: 'index'
  end

  def expired
    @efars = @current_manager.efars.expired.order('id DESC').all
    render action: 'index'
  end

  def search
    search_condition = "%" + params[:search] + "%"
    @efars = @current_manager.efars.where('full_name LIKE ?', search_condition).all
    render action: 'index'
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
