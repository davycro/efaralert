class DispatchMessagesController < ApplicationController

  before_filter :require_dispatcher_login

  # def index
  #   @emergencies = current_dispatcher.emergencies
  #   respond_to do |format|
  #     format.html
  #     format.json { render json: @emergencies }
  #   end
  # end

end
