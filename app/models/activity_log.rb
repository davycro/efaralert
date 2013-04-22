# == Schema Information
#
# Table name: activity_logs
#
#  id         :integer          not null, primary key
#  message    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ActivityLog < ActiveRecord::Base
  attr_accessible :message

  def self.log(message)
    create(message: message)
  rescue
    Rails.logger.info "Could not log this message: #{message}"
  end

  def logged_at_in_cape_town_time_zone
    self.created_at.in_time_zone("Africa/Johannesburg").
      strftime("%I:%M %p - %d %b %y")
  end
end
