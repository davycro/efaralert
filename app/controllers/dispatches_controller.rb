class DispatchesController < ApplicationController

  before_filter :require_dispatcher_login
  layout 'dispatch'

  def index
    respond_to do |format|
      format.html
      format.json {
        @dispatches = current_dispatcher.dispatches.order('created_at DESC').where(:created_at => 24.hours.ago .. Time.now).all
        render json: @dispatches.to_json
      }
    end
  end

  def create
    @dispatch = Dispatch.new params[:dispatch]
    @dispatch.dispatcher = current_dispatcher
    if @dispatch.save
      @dispatch.alert_the_efars!
      @dispatch.alert_the_head_efars!
    end
    respond_to do |format|
      format.json { render json: @dispatch.to_json }
    end
  end
end
