class Admin::ManagersController < InheritedResources::Base
  layout 'admin'
  before_filter :require_admin_login
  respond_to :html, :json, :js

  def create
    create! { admin_managers_path }
  end

  def update
    update! { admin_managers_path }
  end
end
