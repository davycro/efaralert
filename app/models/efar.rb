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
#

# The efar table represents all efars willing to provide a mobile phone number
class Efar < ActiveRecord::Base

  # Individual Attributes
  attr_accessible :full_name, :community_center_id,
    :locations_attributes, :township_id, :contact_number, :township_house_number

  PER_PAGE = 50

  validates :full_name, :community_center_id, :contact_number, :presence => true
  validates :contact_number, :uniqueness => true

  belongs_to :community_center
  has_many :dispatch_messages, :dependent => :destroy
  has_many :locations, :class_name => 'EfarLocation', :dependent => :destroy,
    :inverse_of => :efar
  belongs_to :township

  accepts_nested_attributes_for :locations, :allow_destroy => :true

  before_validation :format_contact_number

  def self.all_for_page(page)  
    page ||= 0
    per_page = PER_PAGE

    return self.limit(per_page).offset(per_page*page).order('created_at DESC').all
  end
  
  def head_efars
    @head_efars ||= self.community_center.head_efars
  end

  def as_json(options = {})
    super(:methods => [:locations])
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

end
