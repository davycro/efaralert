class EfarsController < InheritedResources::Base
  layout 'admin'
  before_filter :require_admin_login
  respond_to :html, :json

  def index
    @efars = Efar.order('id DESC').all
  end

  def map
    respond_to do |format|
      format.json do 
        @efars = Efar.has_geolocation.all
        render json: @efars.to_json
      end
      format.html
    end 
  end

end
