class Admin::DispatchesController < ApplicationController

  layout 'admin'

  before_filter :require_admin_login

  def index
    @dispatches = Dispatch.order('id DESC').all
  end

  def show
    @dispatch = Dispatch.find params[:id]
  end
end
