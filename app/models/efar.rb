class Efar < ActiveRecord::Base
  attr_accessible :first_names, :surname, :contact_number, :address, :suburb, :postal_code,
    :city, :province, :country, :certification_level, :community_center_id, :lat, :lng, 
    :invalid_address, :is_mobile, :location_type, :formatted_address

  PER_PAGE = 50

  validates :surname, :address, 
    :city, :country, :contact_number, :community_center_id, :presence => true
  validates :contact_number, :uniqueness => true

  belongs_to :community_center
  
  geocoded_by :full_address, :latitude => :lat, :longitude => :lng
  after_validation :geocode

  def self.all_for_page(page)  
    page ||= 0
    per_page = PER_PAGE

    return self.limit(per_page).offset(per_page*page).all
  end

  def full_name
    "#{self.first_names} #{self.surname}"
  end

  def full_address
    if @full_address.present?
      return @full_address
    end

    @full_address = self.address
    if self.suburb.present?
      @full_address += ", #{self.suburb}"
    end
    @full_address += ", #{self.city} #{self.postal_code}"
    if self.province.present?
      @full_address += ", #{self.province}"
    end
    @full_address += ", #{self.country}"

    return @full_address
  end
end
