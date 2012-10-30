class EmergenciesController < ApplicationController

  before_filter :require_dispatcher_login
  layout 'dispatch'

  def new
  end

  def index
  end
end
