# == Schema Information
#
# Table name: dispatchers
#
#  id              :integer          not null, primary key
#  full_name       :string(255)      not null
#  password_digest :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Dispatcher < ActiveRecord::Base
  attr_accessible :full_name, :password, :password_confirmation

  has_secure_password

  validates :full_name, :password_digest, :presence => true

  validates :password, :on => :create, :presence => true

  has_many :dispatches

  def dispatch_feed
    # aggregate of slum and emergencies from the last 24 hours
    # sorted by newest first
    Dispatch.where(:dispatcher_id => self.id).
      where(:created_at => 24.hours.ago .. Time.now).
      order('created_at DESC').all
  end 
end
