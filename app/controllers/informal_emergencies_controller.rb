class InformalEmergenciesController < ApplicationController

  before_filter :require_dispatcher_login

  layout 'dispatch'

  def new
    @slum_emergency = SlumEmergency.new
  end

  def show
  end

  def create
    @slum_emergency = SlumEmergency.new(params[:slum_emergency])
    @slum_emergency.dispatcher = current_dispatcher
    if @slum_emergency.save
      @slum_emergency.dispatch_efars!
      @slum_emergency.dispatch_head_efars!
      redirect_to dispatches_path
    else
      render action: 'new'  
    end
  end
end
