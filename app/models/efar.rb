# == Schema Information
#
# Table name: efars
#
#  id                    :integer          not null, primary key
#  full_name             :string(255)      not null
#  community_center_id   :integer          not null
#  contact_number        :string(255)      not null
#  township_id           :integer
#  township_house_number :string(255)
#  lat                   :float
#  lng                   :float
#  formatted_address     :string(255)
#  location_type         :string(255)
#

# The efar table represents all efars willing to provide a mobile phone number
class Efar < ActiveRecord::Base

  # Individual Attributes
  attr_accessible :full_name, 
    :contact_number, 
    :community_center_id,
    :township_id, :township_house_number,
    :lat, :lng, :formatted_address, :location_type

  PER_PAGE = 50

  validates :full_name, :community_center_id, :contact_number, 
    :presence => true
  validates :contact_number, :uniqueness => true

  belongs_to :community_center
  has_many :dispatch_messages, :dependent => :destroy
  belongs_to :township

  scope :has_geolocation, where('lat is not null')

  

  include Extensions::ContactNumber
  include Extensions::CapeTownLocation

  def self.all_for_page(page)  
    page ||= 0
    per_page = PER_PAGE

    return self.limit(per_page).offset(per_page*page).order('id DESC').all
  end
  
  def head_efars
    @head_efars ||= self.community_center.head_efars
  end

  def as_json(options = {})
    super(:methods => [:readable_location, :readable_contact_number])
  end  

end
