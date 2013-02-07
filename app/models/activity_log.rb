class ActivityLog < ActiveRecord::Base
  attr_accessible :message

  def self.log(message)
    create(message: message)
  end

  def logged_at_in_cape_town_time_zone
    self.created_at.in_time_zone("Africa/Johannesburg").
      strftime("%I:%M %p - %d %b %y")
  end
end
