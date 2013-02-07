class ActivityLog < ActiveRecord::Base
  attr_accessible :message

  def self.log(message)
    create(message: message)
  end
end
