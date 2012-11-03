class Api::EfarsController < ApplicationController
  
  # GET /efars.json
  def index
    respond_to do |format|
      format.json do 
        @efars = Efar.valid_location.certified.all
        render json: @efars.to_json
      end
    end
  end
  
end
