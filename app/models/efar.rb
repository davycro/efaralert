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

  before_validation :format_contact_number

  def self.all_for_page(page)  
    page ||= 0
    per_page = PER_PAGE

    return self.limit(per_page).offset(per_page*page).order('id DESC').all
  end
  
  def head_efars
    @head_efars ||= self.community_center.head_efars
  end

  def as_json(options = {})
    super(:methods => [])
  end

  def send_text_message(message)
    return SMS_API.send_message(self.contact_number, message)
  end

  def format_contact_number
    return false if contact_number.blank?
    num = self.contact_number.to_s
    if num.length < 9
      errors.add(:contact_number, "must be at least nine digits")
      return false
    end
    if num[0..1] == "27"
      return true
    end
    if num[0] == "0"
      num = num[1..-1]
    end
    self.contact_number = "27#{num}"
    return true
  end

  def readable_location
    return @readable_location if @readable_location.present?
    @readable_location = ""
    if township_id.present?
      @readable_location = "#{township_house_number} #{township.name}" 
    else
      @readable_location = "#{formatted_address}"
    end
    return @readable_location
  end

end
