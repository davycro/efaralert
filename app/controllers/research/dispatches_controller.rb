class Research::DispatchesController < ApplicationController
  layout 'research'
  before_filter :require_researcher_login

  def index
  end
end
