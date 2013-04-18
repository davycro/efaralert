class EfarsController < ApplicationController

  before_filter :require_dispatcher_login
  layout 'dispatch'

  def index
    respond_to do |format|
      format.json do
        @efars = Efar.near([current_suburb.lat, current_suburb.lng], 5).all # km
        render json: @efars.to_json
      end
      format.html
    end
  end
end
