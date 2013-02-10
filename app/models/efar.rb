# == Schema Information
#
# Table name: efars
#
#  id                  :integer          not null, primary key
#  full_name           :string(255)      not null
#  community_center_id :integer          not null
#  slum_id             :integer
#

# The efar table represents all efars willing to provide a mobile phone number
class Efar < ActiveRecord::Base

  # Individual Attributes
  attr_accessible :full_name, :community_center_id, :contact_numbers_attributes,
    :locations_attributes

  PER_PAGE = 50

  validates :full_name, :community_center_id, :presence => true

  belongs_to :community_center
  has_many :dispatch_messages
  has_many :locations, :class_name => 'EfarLocation', :dependent => :destroy,
    :inverse_of => :efar
  has_many :contact_numbers, :class_name => 'EfarContactNumber',
    :dependent => :destroy, :inverse_of => :efar

  accepts_nested_attributes_for :contact_numbers, :allow_destroy => :true,
    :reject_if => :all_blank

  accepts_nested_attributes_for :locations, :allow_destroy => :true

  def self.all_for_page(page)  
    page ||= 0
    per_page = PER_PAGE

    return self.limit(per_page).offset(per_page*page).all
  end
  
  def head_efars
    @head_efars ||= self.community_center.head_efars
  end

  def as_json(options = {})
    super(:methods => [:locations, :contact_numbers])
  end

  def send_text_message(message)
    responses = []
    self.contact_numbers.each do |contact_number|
      responses << SMS_API.send_message(contact_number.contact_number, message)
    end
    # return a success response if there is one
    responses.each do |response|
      if response[:status]=='success'
        return response
      end
    end
    # if not, then just return any random response
    return responses.first
  end

  def contact_number
    self.contact_numbers.first.contact_number
  end

end
