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

require 'test_helper'

class AlertSmsTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
