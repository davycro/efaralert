class Research::CommunityCentersController < ApplicationController
  before_filter :require_researcher_login
  
  # GET /community_centers.json
  def index
    respond_to do |format|
      format.json do 
        render json: CommunityCenter.all.to_json
      end
    end
  end

end
