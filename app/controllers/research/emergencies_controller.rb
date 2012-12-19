class Research::EmergenciesController < ApplicationController

  before_filter :require_researcher_login

  layout 'research'

  def live
  end

  def live_static
  end

end
