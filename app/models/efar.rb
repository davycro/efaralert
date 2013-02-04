# == Schema Information
#
# Table name: efars
#
#  id                  :integer          not null, primary key
#  full_name           :string(255)      not null
#  community_center_id :integer          not null
#

# The efar table represents all efars willing to provide a mobile phone number
class Efar < ActiveRecord::Base

  # Individual Attributes
  attr_accessible :full_name, :community_center_id

  PER_PAGE = 50

  validates :full_name, :community_center_id, :presence => true

  belongs_to :community_center
  has_many :dispatch_messages
  has_many :locations, :class_name => 'EfarLocation'
  has_many :contact_numbers, :class_name => 'EfarContactNumber'

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
    return responses
  end

end
