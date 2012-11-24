class Research::EmergenciesController < ApplicationController

  before_filter :require_researcher_login

  layout 'research'

  def live
    @emergencies = Emergency.order("created_at DESC").all
  end

  def live_static
  end

end
