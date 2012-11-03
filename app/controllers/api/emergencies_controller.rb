class Api::EmergenciesController < ApplicationController
  
  # GET /emergencies.json
  def index
    respond_to do |format|
      format.json do 
        @emergencies = Emergency.all
        render json: @emergencies.to_json(:methods => [:efar_ids])
      end
    end
  end
  
end
