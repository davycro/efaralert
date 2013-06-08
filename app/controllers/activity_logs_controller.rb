class ActivityLogsController < InheritedResources::Base
  layout 'admin'
  before_filter :require_admin_login

  def index
    @activity_log = ActivityLog.order('created_at DESC').all
  end

end
