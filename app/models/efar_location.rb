# == Schema Information
#
# Table name: efar_locations
#
#  id                :integer          not null, primary key
#  efar_id           :integer          not null
#  occupied_at       :string(255)
#  given_address     :string(255)      not null
#  formatted_address :string(255)      not null
#  lat               :float            not null
#  lng               :float            not null
#  location_type     :string(255)
#

class EfarLocation < ActiveRecord::Base

  #
  # Time of day when location is occupied
  # eg daytime, nighttime, anytime
  attr_accessible :occupied_at

  # geocoding attributes
  attr_accessible :given_address, :formatted_address, :lat, :lng,
    :location_type

  validates :given_address, :efar_id, :presence => true
  after_validation :geocode

  geocoded_by :given_address,
    :latitude => :lat, :longitude => :lng do |obj, results|
    if geo = results.first
      obj.lat           = geo.latitude
      obj.lng           = geo.longitude
      obj.location_type = geo.types.first
    end
  end

  scope :valid_location,
    where("location_type not in (?) and location_type is not null", 
      %w{sublocality postal_code administrative_area_level_1 locality})

  belongs_to :efar


end
