class Api::DispatchMessagesController < ApplicationController
  
  def index
    respond_to do |format|
      format.json do
        if params[:dispatch_id].present?
          @dispatch_messages = DispatchMessage.where(:dispatch_id => params[:dispatch_id]).all
        else 
          @dispatch_messages = DispatchMessage.all
        end
        render json: @dispatch_messages.to_json
      end
    end
  end
  
end
