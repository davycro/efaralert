# == Schema Information
#
# Table name: alert_sms
#
#  id         :integer          not null, primary key
#  efar_id    :integer          not null
#  alert_id   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AlertSms < ActiveRecord::Base
  attr_accessible :efar_id, :alert_id

  belongs_to :efar
  belongs_to :alert

  def deliver
    landmarks = ""
    if self.alert.landmarks.present?
      landmarks = "(#{self.alert.landmarks})"
    end

    self.efar.send_text_message %{
      EFAR Alert: #{self.alert.incident_type} at "#{self.alert.given_location}" 
      #{landmarks}. Do not assist unless SAFE!
    }.squish
  end
end
