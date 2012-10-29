class CommunityCenter < ActiveRecord::Base
  attr_accessible :street, :city, :country, :name, :postal_code, :province, :suburb

  # Geocoding Attributes
  attr_accessible :lat, :lng, :location_type, :formatted_address

  validates :street, :city, :country, :name, :postal_code,
    :presence => true

  has_many :efars
  
  geocoded_by :geocode_search_address, :latitude => :lat, :longitude => :lng do |obj, results|
    if geo = results.first
      obj.lat = geo.latitude
      obj.lng = geo.longitude
      obj.location_type = geo.types.first
      obj.formatted_address = geo.formatted_address
    end
  end 

  def geocode_search_address
    [street, suburb, city, postal_code, province, country].compact.join(", ")
  end
end
