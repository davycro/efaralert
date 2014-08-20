class EfarsController < ApplicationController
	before_filter :require_manager_login
  before_filter :set_page
	layout 'main'

  def index
    @efars = efar_selector.all
    @efars_group_title = ""
  end

  def active
    @efars = efar_selector.active.all
    @efars.delete_if { |e| e.not_competent? }
    @efars_group_title = "Active"
    render action: 'index'
  end

  def bibbed
    @efars = efar_selector.has_bib.all
    @efars_group_title = "Bibbed"
    render action: 'index'
  end

  def nyc
    @efars = efar_selector.all
    @efars.delete_if { |e| !e.not_competent? }
    @efars_group_title = "Not yet competent"
    render action: 'index'
  end

  def expired
    @efars = efar_selector.expired.all
    @efars_group_title = "Expired"
    render action: 'index'
  end

  def search
    search_condition = "%" + params[:search] + "%"
    @efars = efar_selector.where('full_name LIKE ?', search_condition).all
    @efars_group_title = ""
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
      record_manager_activity "updated efar #{@efar.full_name}"
      redirect_to efars_path, notice: "EFAR updated"
    else
      render action: 'edit'
    end
  end

  def create
    @efar = Efar.new params[:efar]
    @efar.community_center = @current_manager.community
    if @efar.save
      record_manager_activity "created EFAR #{@efar.full_name}"
      redirect_to efars_path, notice: "EFAR created"
    else
      puts "FAILED TO SAVE EFAR: #{@efar.errors.to_json}" if Rails.env.test?
      render action: 'new'
    end
  end

  def text_message
    respond_to do |format|
      format.json do
        @efar = Efar.find(params[:id])
        @efar.send_text_message params[:message]
        render json: @efar
      end
    end
  end

  def destroy
    @efar = Efar.find params[:id]
    @efar.destroy
    record_manager_activity "removed EFAR: #{@efar.full_name}"
    redirect_to efars_path, notice: "EFAR removed"
  end

  protected

    def set_page
      params[:page] ||= 1
      @page = params[:page]
    end

    def record_manager_activity(message)
      ActivityLog.log "#{current_manager.full_name}: #{message}"
    end

    def efar_selector
      @current_manager.efars.order('id DESC')      
    end

end
