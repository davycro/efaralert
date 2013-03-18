class EfarsController < ApplicationController

  before_filter :require_dispatcher_login
  layout 'dispatch'

  def index
    respond_to do |format|
      format.json do
        @efars = Efar.has_geolocation.all
        render json: @efars.to_json
      end
      format.html
    end
  end
end
