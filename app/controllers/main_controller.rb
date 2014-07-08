class MainController < ApplicationController
  layout 'main'

  def landing
    redirect_to admin_efars_url
  end

  def register
  end
end
