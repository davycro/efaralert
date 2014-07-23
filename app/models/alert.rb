# == Schema Information
#
# Table name: alerts
#
#  id                       :integer          not null, primary key
#  given_location           :string(255)
#  landmarks                :string(255)
#  incident_type            :string(255)
#  lat                      :float
#  lng                      :float
#  formatted_address        :string(255)
#  location_type            :string(255)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  control_group            :boolean          default(FALSE)
#  distance_of_nearest_efar :float
#

class Alert < ActiveRecord::Base
  attr_accessible :given_location, :landmarks, :incident_type, :lat, :lng,
    :formatted_address, :location_type, :distance_of_nearest_efar

  geocoded_by :formatted_address, :latitude => :lat, :longitude => :lng

  has_many :alert_sms, :dependent => :destroy, class_name: 'AlertSms'

  EFAR_SEARCH_RADIUS = 2 # km

  def deliver_sms
    self.nearby_efars.each do |efar|
      sms = AlertSms.create(efar_id: efar.id, alert_id: self.id)  
      sms.deliver
    end
  end

  def nearby_efars
    efars = []
    efars += Efar.alert_subscriber.near [self.lat, self.lng], EFAR_SEARCH_RADIUS, :units => :km
    efars += Efar.alert_subscriber.where(training_level: 'Head Community Instructor').all
    efars
  end

  def nearest_efar
    @nearest_efar ||= Efar.alert_subscriber.near([self.lat, self.lng], 
      EFAR_SEARCH_RADIUS, :units => :km, :order => 'distance').first
  end

  def set_distance_of_nearest_efar
    if nearest_efar.present?
      self.distance_of_nearest_efar = nearest_efar.distance
      self.save
    end   
  end
end
