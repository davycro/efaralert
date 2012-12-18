# == Schema Information
#
# Table name: community_centers
#
#  id                :integer          not null, primary key
#  name              :string(255)      not null
#  street            :string(255)      not null
#  suburb            :string(255)
#  postal_code       :string(255)      not null
#  city              :string(255)      not null
#  province          :string(255)
#  country           :string(255)      not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  lat               :float
#  lng               :float
#  location_type     :string(255)
#  formatted_address :string(255)
#

class CommunityCenter < ActiveRecord::Base
  attr_accessible :street, :city, :country, :name, :postal_code, :province, :suburb

  # Geocoding Attributes
  attr_accessible :lat, :lng, :location_type, :formatted_address

  validates :street, :city, :country, :name, :postal_code,
    :presence => true

  has_many :efars
  has_one :head_efar
  
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
