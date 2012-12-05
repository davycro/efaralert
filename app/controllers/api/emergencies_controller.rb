class Api::EmergenciesController < ApplicationController
  
  # GET /emergencies.json
  def index
    respond_to do |format|
      format.json do 
        @emergencies = Emergency.all
        render json: @emergencies
      end
    end
  end
  
end
