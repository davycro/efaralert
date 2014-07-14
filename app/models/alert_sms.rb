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
    Rails.logger.info "Deliver SMS to #{efar.full_name} for emergency at #{alert.formatted_address}"
  end
end
