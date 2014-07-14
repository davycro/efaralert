# == Schema Information
#
# Table name: alerts
#
#  id                :integer          not null, primary key
#  given_location    :string(255)
#  landmarks         :string(255)
#  incident_type     :string(255)
#  lat               :float
#  lng               :float
#  formatted_address :string(255)
#  location_type     :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Alert < ActiveRecord::Base
  attr_accessible :given_location, :landmarks, :incident_type, :lat, :lng,
    :formatted_address, :location_type

  geocoded_by :formatted_address, :latitude => :lat, :longitude => :lng

  has_many :alert_sms, :dependent => :destroy, class_name: 'AlertSms'

  def deliver_sms
    self.nearby_efars.each do |efar|
      sms = AlertSms.create(efar_id: efar.id, alert_id: self.id)  
      sms.deliver
    end
  end

  def nearby_efars
    Efar.near [self.lat, self.lng], 0.5, :units => :km
  end
end
