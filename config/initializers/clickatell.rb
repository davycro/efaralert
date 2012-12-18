# clickatell
if ENV['PRECOMPILE_ENV'].blank?
  SMS_API = SmsApi.new
else
  SMS_API = nil
end

