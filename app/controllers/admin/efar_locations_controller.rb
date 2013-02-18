class Admin::EfarLocationsController < ApplicationController

  # GET /efar_locations.json
  def index
    respond_to do |format|
      format.json do 
        @efar_locations = EfarLocation.all
        render json: @efar_locations.to_json(:methods => :efar)
      end
    end
  end
end
