class Api::DispatchMessagesController < ApplicationController
  
  def index
    respond_to do |format|
      format.json do 
        @dispatch_messages = DispatchMessage.all
        render json: @dispatch_messages.to_json(:methods => [:lat, :lng])
      end
    end
  end
  
end
