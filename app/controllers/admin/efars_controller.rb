class Admin::EfarsController < ApplicationController
  layout 'efar_admin'

  before_filter :require_admin_login

  def index
    params[:page] ||= 0
    @page = params[:page].to_i
    @efars = Efar.all_for_page(@page)
  end
end
