class Admin::AdminsController < ApplicationController
  layout 'efar_chrome'

  before_filter :require_admin_login

  def index
  end


end
