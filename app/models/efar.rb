# The efar table has loose requriements
class Efar < ActiveRecord::Base

  # Individual Attributes
  attr_accessible :first_names, :surname, :contact_number, :community_center_id

  # Location Attributes
  attr_accessible :street, :suburb, :postal_code, :city, :province, :country

  # Geocoding Attributes
  attr_accessible :lat, :lng, :location_type, :formatted_address

  # Personal Attributes
  attr_accessible :first_language, :birthday, :profile

  # Training Attributes
  attr_accessible :training_date, :training_location, :training_score, :training_instructor  

  PER_PAGE = 50

  validates :surname, :street, :city, :country, :community_center_id, :presence => true

  belongs_to :community_center


  # scopes
  scope :valid_location, where("location_type not in (?) and location_type is not null", 
    %w{sublocality postal_code administrative_area_level_1 locality})

  def self.all_for_page(page)  
    page ||= 0
    per_page = PER_PAGE

    return self.limit(per_page).offset(per_page*page).all
  end

  def full_name
    "#{self.first_names} #{self.surname}"
  end

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
