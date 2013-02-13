class DispatchesController < ApplicationController

  before_filter :require_dispatcher_login
  layout 'dispatch'

  def index
    @dispatches = current_dispatcher.dispatches
  end

  def show
    @dispatch = Dispatch.find(params[:id])
  end

  def new
    @dispatch = Dispatch.new
  end

  def create
    @dispatch = Dispatch.new params[:dispatch]
    if @dispatch.save
      redirect_to @dispatch
    else
      render action: 'new'
    end
  end
end
