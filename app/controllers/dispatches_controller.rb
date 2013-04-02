class DispatchesController < ApplicationController

  before_filter :require_dispatcher_login
  layout 'dispatch'

  def index
    @dispatches = current_dispatcher.dispatches.order('created_at DESC').all
    respond_to do |format|
      format.html
      format.json { render json: @dispatches.to_json }
    end
  end

  def show
    @dispatch = Dispatch.find(params[:id])
  end

  def new
    @dispatch = Dispatch.new
  end

  def create
    @dispatch = Dispatch.new params[:dispatch]
    @dispatch.dispatcher = current_dispatcher
    if @dispatch.save
      @dispatch.alert_the_efars!
      @dispatch.alert_the_head_efars!
      redirect_to @dispatch
    else
      render action: 'new'
    end
  end
end
