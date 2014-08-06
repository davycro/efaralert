class Admin::EfarsController < ApplicationController
  layout 'admin'
  before_filter :require_admin_login
  respond_to :html, :json, :js

  def index
    @efars = efar_selector.all
    render action: 'index'
  end

  def expired
    @efars = efar_selector.expired.all
    @efars_group_title = "Expired" 
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

  def active
    @efars = efar_selector.active.all
    @efars.delete_if { |e| e.not_competent? }
    @efars_group_title = "Active"
    render action: 'index'
  end

  def map
    respond_to do |format|
      format.json do 
        # @efars = Efar.alert_subscriber.all
        @efars = Efar.has_geolocation.all
        render json: @efars.to_json
      end
      format.html
    end 
  end

  def near
    respond_to do |format|
      format.json do
        @efars = Efar.alert_subscriber.near([params[:lat], params[:lng]], Alert::EFAR_SEARCH_RADIUS, :units => :km)
        render json: @efars.to_json
      end
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

  def alert_subscribers
    @efars = Efar.alert_subscriber.order('id DESC').all
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
      redirect_to admin_efars_path, notice: "EFAR updated"
    else
      render action: 'edit'
    end
  end

  def create
    @efar = Efar.new params[:efar]
    if @efar.save
      redirect_to admin_efars_path, notice: "EFAR created"
    else
      puts "FAILED TO SAVE EFAR: #{@efar.errors.to_json}" if Rails.env.test?
      render action: 'new'
    end
  end

  def destroy
    @efar = Efar.find params[:id]
    @efar.destroy
    redirect_to efars_path, notice: "EFAR removed"
  end

  protected

    def efar_selector
      if params[:community_center_id].present?
        @community = CommunityCenter.find params[:community_center_id]
      end
      if @community
        selector = @community.efars
      else
        selector = Efar
      end
      selector = selector.order('id DESC')
      return selector
    end

end
