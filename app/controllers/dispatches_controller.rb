class DispatchesController < ApplicationController

  before_filter :require_dispatcher_login
  layout 'dispatch'

  def index
    @records = current_dispatcher.dispatch_feed
  end
end
