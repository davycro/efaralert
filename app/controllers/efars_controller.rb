class EfarsController < InheritedResources::Base
  layout 'admin'
  before_filter :require_admin_login
  respond_to :html, :json, :js

  def map
    respond_to do |format|
      format.json do 
        @efars = Efar.has_geolocation.all
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
        # raise "error!"
      end
    end
  end

  protected
    def collection
      @efars ||= Efar.order('id DESC').all
    end

end
