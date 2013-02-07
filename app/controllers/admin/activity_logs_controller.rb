class Admin::ActivityLogsController < ApplicationController

  layout 'admin'

  before_filter :require_admin_login

  def index
    @activity_log = ActivityLog.all
    respond_to do |format|
      format.html
      format.json do 
        render json: @activity_log.to_json
      end
    end
  end

end
