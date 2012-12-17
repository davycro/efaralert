class ClickatellController < ApplicationController

  # {"api_id"=>"3404223", "from"=>"27846715721", "to"=>"27840044259", "timestamp"=>"2012-12-17 11:36:48", "text"=>"Yes", "charset"=>"ISO-8859-1", "udh"=>"", "moMsgId"=>"7bb7f1001bad8bb576833fc9b1004df3"}
  def callback
    # lookup efar by contact number
    # assume that response is for the latest dispatch message
    text = params[:text]
    efar = Efar.find_by_contact_number params[:from]
    dispatch_message = efar.dispatch_messages.order('created_at DESC').first
    Rails.logger.info dispatch_message
    if params[:text].present?
      dispatch_message.process_response text
    end
    render :text => 'done'
  end

end
