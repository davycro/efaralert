class Api::DispatchMessagesController < ApplicationController
  
  def index
    respond_to do |format|
      format.json do
        if params[:emergency_id].present?
          @dispatch_messages = DispatchMessage.where(:emergency_id => params[:emergency_id]).all
        else 
          @dispatch_messages = DispatchMessage.all
        end
        render json: @dispatch_messages.to_json
      end
    end
  end
  
end
