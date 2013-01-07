# == Schema Information
#
# Table name: efars
#
#  id                  :integer          not null, primary key
#  surname             :string(255)      not null
#  first_name          :string(255)      not null
#  community_center_id :integer          not null
#  contact_number      :string(255)      not null
#  street              :string(255)      not null
#  suburb              :string(255)
#  postal_code         :string(255)
#  city                :string(255)      not null
#  province            :string(255)
#  country             :string(255)      not null
#  lat                 :float
#  lng                 :float
#  location_type       :string(255)
#  first_language      :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

# The efar table represents all efars willing to provide a mobile phone number
class Efar < ActiveRecord::Base

  # Individual Attributes
  attr_accessible :first_name, :surname, :contact_number, :community_center_id

  # Location Attributes
  attr_accessible :street, :suburb, :postal_code, :city, :province, :country

  # Geocoding Attributes
  attr_accessible :lat, :lng, :location_type, :formatted_address

  # Personal Attributes
  attr_accessible :first_language

  PER_PAGE = 50

  validates :surname, :street, :city, :country, :community_center_id, 
    :contact_number, :presence => true

  belongs_to :community_center
  has_many :dispatch_messages


  # scopes
  scope :valid_location,
    where("location_type not in (?) and location_type is not null", 
      %w{sublocality postal_code administrative_area_level_1 locality})

  def self.all_for_page(page)  
    page ||= 0
    per_page = PER_PAGE

    return self.limit(per_page).offset(per_page*page).all
  end

  def full_name
    "#{self.first_name} #{self.surname}"
  end

  geocoded_by :geocode_search_address,
    :latitude => :lat, :longitude => :lng do |obj, results|
    if geo = results.first
      obj.lat               = geo.latitude
      obj.lng               = geo.longitude
      obj.location_type     = geo.types.first
    end
  end 

  def geocode_search_address
    [street, suburb, city, postal_code, province, country].compact.join(", ")
  end

  def contact_number_formatted_for_clickatell
    # TODO make this error proof
    # quick shim, add +27 to the number
    "#{self.contact_number}"
  end

  def head_efar
    @head_efar ||= self.community_center.head_efar
  end

  def as_json(options = {})
    super(:methods => [:lat, :lng, :full_name])
  end

  def set_defaults
    if self.new_record?
      self.city           = "Cape Town"
      self.province       = "Western Cape"
      self.country        = "South Africa"
      self.first_language = "English"
    end
  end

end
