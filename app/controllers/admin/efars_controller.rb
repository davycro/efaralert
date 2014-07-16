class Admin::EfarsController < InheritedResources::Base
  layout 'admin'
  before_filter :require_admin_login
  respond_to :html, :json, :js

  def expired
    @efars = Efar.expired.order('id DESC').all
    render action: 'index'
  end

  def message
    @community_centers = CommunityCenter.all
  end

  def map
    respond_to do |format|
      format.json do 
        @efars = Efar.alert_subscriber.all
        render json: @efars.to_json
      end
      format.html
    end 
  end

  def text_message
    respond_to do |format|
      format.json do
        @efar = Efar.find(params[:id])
        @efar.send_text_message params[:message]
        render json: @efar
      end
    end
  end

  def alert_subscribers
    @efars = Efar.alert_subscriber.order('id DESC').all
    render action: 'index'
  end

  protected
    def collection
      @efars ||= Efar.active.order('id DESC').all
    end

end
