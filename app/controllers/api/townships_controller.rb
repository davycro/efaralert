class Api::TownshipsController < ApplicationController
  
  def index
    respond_to do |format|
      format.json do 
        @townships = Township.all
        render json: @townships.to_json
      end
    end
  end
  
end
