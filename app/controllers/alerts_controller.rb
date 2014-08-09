class AlertsController < ApplicationController
  layout 'admin'
  before_filter :require_admin_login
  respond_to :json, :html

  def show
  end

  def index
    @alerts = Alert.order('id DESC').all
  end

  def efars_map
    respond_to do |format|
      format.json do
        @efars = Efar.alert_subscriber.all
        render json: @efars
      end
    end
  end

  def new
  end

  def create
    @alert = Alert.new params[:alert]
    @alert.control_group = [false,true].sample
    if @alert.save
      @alert.deliver_sms unless @alert.control_group
      @alert.set_distance_of_nearest_efar
    end
    respond_with @alert
  end
end
