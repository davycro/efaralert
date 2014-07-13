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
  # attr_accessible :title, :body
end
