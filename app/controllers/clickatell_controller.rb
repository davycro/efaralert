class ClickatellController < ApplicationController

  # {"api_id"=>"3404223", "from"=>"27846715721", "to"=>"27840044259", "timestamp"=>"2012-12-17 11:36:48", "text"=>"Yes", "charset"=>"ISO-8859-1", "udh"=>"", "moMsgId"=>"7bb7f1001bad8bb576833fc9b1004df3"}
  def callback
    # lookup efar by contact number
    # assume that response is for the latest dispatch message
    text = params[:text]
    dispatch_message = DispatchMessage.find_most_active_for_number(params[:from])
    slum_dispatch_message = SlumDispatchMessage.find_most_active_for_number params[:from]
    ActivityLog.log "SMS received from #{params[:from]}. Message: #{params[:text]}"
    if params[:text].present? and dispatch_message.present?
      dispatch_message.process_response text
    end
    if params[:text].present? and slum_dispatch_message.present?
      slum_dispatch_message.process_response text
    end
    render :text => 'done'
  end

end
