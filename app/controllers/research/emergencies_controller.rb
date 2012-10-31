class Research::EmergenciesController < ApplicationController
  layout 'research'
  before_filter :require_researcher_login

  def index
    @emergencies = Emergency.all
    respond_to do |format|
      format.html
      format.json { render json: @emergencies.to_json(:methods => [:num_efars_notified]) }
    end
  end

end
