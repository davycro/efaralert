# == Schema Information
#
# Table name: efars
#
#  id                  :integer          not null, primary key
#  surname             :string(255)      not null
#  first_names         :string(255)      default("Anon")
#  community_center_id :integer          not null
#  contact_number      :string(255)
#  street              :string(255)      not null
#  suburb              :string(255)
#  postal_code         :string(255)
#  city                :string(255)      not null
#  province            :string(255)
#  country             :string(255)      not null
#  lat                 :float
#  lng                 :float
#  location_type       :string(255)
#  formatted_address   :string(255)
#  first_language      :string(255)
#  birthday            :date
#  profile             :string(255)
#  training_date       :date
#  training_score      :float
#  training_location   :string(255)
#  training_instructor :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

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
  attr_accessible :training_date, :training_location, :training_score,
    :training_instructor  

  PER_PAGE = 50

  validates :surname, :street, :city, :country, :community_center_id,
    :presence => true

  belongs_to :community_center
  has_many :dispatch_messages


  # scopes
  scope :valid_location,
    where("location_type not in (?) and location_type is not null", 
      %w{sublocality postal_code administrative_area_level_1 locality})

  scope :certified, where("training_score >= 0.8")

  scope :owns_mobile_phone, where("contact_number IS NOT NULL")

  def self.all_for_page(page)  
    page ||= 0
    per_page = PER_PAGE

    return self.limit(per_page).offset(per_page*page).all
  end

  def full_name
    "#{self.first_names} #{self.surname}"
  end

  geocoded_by :geocode_search_address,
    :latitude => :lat, :longitude => :lng do |obj, results|
    if geo = results.first
      obj.lat               = geo.latitude
      obj.lng               = geo.longitude
      obj.location_type     = geo.types.first
      obj.formatted_address = geo.formatted_address
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

end
