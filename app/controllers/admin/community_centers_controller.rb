class Admin::CommunityCentersController < ApplicationController
  layout 'efar_admin'

  before_filter :require_admin_login

  def index
    @community_centers = CommunityCenter.all
  end

  def edit
    @community_center = CommunityCenter.find(params[:id])
  end

  def new
    @community_center = CommunityCenter.new
  end

  def show
    @community_center = CommunityCenter.find(params[:id])
  end

  def create
    @community_center = CommunityCenter.new(params[:community_center])
    if @community_center.save
      redirect_to admin_community_centers_path, :notice => "New community center created"
    else
      render :action => 'new'
    end
  end

  def update
    @community_center = CommunityCenter.find(params[:id])
    if @community_center.update_attributes(params[:community_center])
      redirect_to admin_community_centers_path, :notice => "Changes saved"
    else
      render :action => 'edit'
    end
  end

  def destroy
    @community_center = CommunityCenter.find(params[:id])
    @community_center.destroy
    redirect_to admin_community_centers_path, :notice => "Community center destroyed"
  end
end
