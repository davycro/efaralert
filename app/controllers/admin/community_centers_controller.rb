class Admin::CommunityCentersController < InheritedResources::Base
  layout 'admin'

  before_filter :require_admin_login
  respond_to :html, :json, :js

  def create
    create! { admin_community_centers_path }
  end

  def update
    update! { admin_community_centers_path }
  end

  def destroy
    @community_center = CommunityCenter.find(params[:id])
    if @community_center.efars.present?
      redirect_to admin_community_centers_path, :notice => "There are #{@community_center.efars.size} EFARs linked to this community center. You must unlink them before you can delete the community center"
    else
      destroy!
    end
  end

end
