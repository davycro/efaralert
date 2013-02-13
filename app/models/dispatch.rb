class Dispatch < ActiveRecord::Base
  attr_accessible :dispatcher_id, :emergency_category, :geolocation_id, 
    :landmarks, :township_id, :township_house_number, :formatted_address, :lat, 
    :lng, :location_type

  EMERGENCY_CATEGORIES = [
    'General emergency',
    'Uncontrolled bleed',
    'Motor vehicle accident',
    'Broken bone',
    'Unconscious person',
    'Fall from a height',
    'Seizure',
    'Burn',
    'Impaled object',
    'Shortness of breath',
    'Abdominal pain',
    'Confused person'
  ]
  
  validates :dispatcher_id, :presence => true

  belongs_to :dispatcher
  belongs_to :township

  validates :township_house_number, :township_id, :presence => true, :if => :nil_geolocation?
 
  def nil_geolocation?
    lng.blank? or lat.blank?
  end

  def readable_location
    return @readable_location if @readable_location.present?
    @readable_location = ""
    if township_id.present?
      @readable_location = "#{township_house_number} #{township.name}" 
    else
      @readable_location = "#{formatted_address}"
    end
    if landmarks.present?
      @readable_location += " (#{landmarks})"
    end
    return @readable_location
  end
end
