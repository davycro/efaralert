class ClickatellController < ApplicationController

  # {"api_id"=>"3404223", "from"=>"27846715721", "to"=>"27840044259", "timestamp"=>"2012-12-17 11:36:48", "text"=>"Yes", "charset"=>"ISO-8859-1", "udh"=>"", "moMsgId"=>"7bb7f1001bad8bb576833fc9b1004df3"}
  def callback

    ActivityLog.log "SMS received from #{params[:from]}. Message: #{params[:text]}"

    text           = params[:text]
    contact_number = params[:from]
    if contact_number[0]=="0"
      contact_number = "27" + contact_number[1..-1]
    end
    if text.present? and contact_number.present?
      efar = Efar.find_by_contact_number contact_number
      if efar.present?
        text_message = TextMessage.create(content: text,
            efar_id: efar.id,
            sender_class_name: 'Efar',
            sender_name: efar.full_name
          )
        ActivityLog.log "SMS from #{efar.full_name}: #{text}"
      end
    end

    render :text => 'done'
  end

end
