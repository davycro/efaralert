class Geolocation < ActiveRecord::Base
  attr_accessible :formatted_address, :lat, :lng, :location_type
end
