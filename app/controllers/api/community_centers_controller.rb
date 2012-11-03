class Api::CommunityCentersController < ApplicationController

  # GET /community_centers.json
  def index
    respond_to do |format|
      format.json do 
        render json: CommunityCenter.all.to_json
      end
    end
  end
  
end
