class Research::MapsController < ApplicationController

  before_filter :require_researcher_login

  layout 'research'

  def show
  end
end
