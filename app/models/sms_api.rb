class SmsApi

  attr :api

  def initialize
    self.authenticate unless in_silent_mode?
  end

  # don't sent text messages in dev environment
  def in_silent_mode?
    if ENV['CLICKATELL_SILENT_MODE'].present? and ENV['CLICKATELL_SILENT_MODE']=='1'
      return true
    else
      return false
    end
  end

  def send_message(number, message, opts={})
    if in_silent_mode?
      log 'in silent mode, no message sent!'
      return {:status => 'success', :clickatell_id => '123'}
    end

    retries = 1
    tries = 0

    response = {}
    begin
      message_id = @api.send_message(number, message, 
        :set_mobile_originated => true, 
        :from => '44259', 
        :mo=>'1',
        :concat => '3',
        :client_message_id => opts[:client_message_id])
      if message_id.present?
        ActivityLog.log "Text message sent to #{number}: \"#{message}\""
        response[:status] = 'success'
        response[:clickatell_id] = message_id
      else
        respose[:status] = 'failed'
        response[:clickatell_error_message] = 'no message id'
      end
    rescue Clickatell::API::Error => e
      # retry expired session problem
      if tries < retries
        self.authenticate
        tries += 1
        retry
      else
        ActivityLog.log "Failed to text message #{number}: \"#{message}\". Reason: #{e.message}"
        response[:status] = 'failed'
        response[:clickatell_error_message] = e.message
      end
    end

    return response
  end

  def authenticate
    @api = Clickatell::API.authenticate ENV['CLICKATELL_API_ID'], 
      ENV['CLICKATELL_USERNAME'], ENV['CLICKATELL_PASSWORD']
  end

  def log(message)
    Rails.logger.info "SMS API: #{message}"
  end

end