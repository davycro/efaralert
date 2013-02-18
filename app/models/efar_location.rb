# == Schema Information
#
# Table name: efar_locations
#
#  id                :integer          not null, primary key
#  efar_id           :integer          not null
#  occupied_at       :string(255)
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
  attr_accessible :formatted_address, :lat, :lng,
    :location_type

  geocoded_by :formatted_address, :latitude => :lat, :longitude => :lng

  validates :lat, :lng, :formatted_address, :presence => true

  scope :valid_location,
    where("location_type not in (?) and location_type is not null", 
      %w{sublocality postal_code administrative_area_level_1 locality})

  belongs_to :efar

end
