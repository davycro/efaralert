class SmsApi

  attr :api

  def initialize
    self.authenticate
  end

  def send_message(number, message)
    retries = 1
    tries = 0

    response = {}
    begin
      message_id = @api.send_message(number, message)
      if message_id.present?
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

end