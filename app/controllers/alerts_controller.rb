class AlertsController < ApplicationController
  layout 'admin'
  before_filter :require_admin_login
  respond_to :json, :html

  def show
  end

  def index
    @alerts = Alert.order('id DESC').all
  end

  def new
  end

  def create
    @alert = Alert.new params[:alert]
    @alert.control_group = [false,true].sample
    if @alert.save && !@alert.control_group
      @alert.deliver_sms
      @alert.set_distance_of_nearest_efar
    end
    respond_with @alert
  end
end
