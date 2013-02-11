# == Schema Information
#
# Table name: efars
#
#  id                  :integer          not null, primary key
#  full_name           :string(255)      not null
#  community_center_id :integer          not null
#  slum_id             :integer
#  contact_number      :string(255)      not null
#

# The efar table represents all efars willing to provide a mobile phone number
class Efar < ActiveRecord::Base

  # Individual Attributes
  attr_accessible :full_name, :community_center_id,
    :locations_attributes, :slum_id, :contact_number

  PER_PAGE = 50

  validates :full_name, :community_center_id, :contact_number, :presence => true
  validates :contact_number, :uniqueness => true

  belongs_to :community_center
  has_many :dispatch_messages
  has_many :slum_dispatch_messages
  has_many :locations, :class_name => 'EfarLocation', :dependent => :destroy,
    :inverse_of => :efar
  belongs_to :slum

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
    super(:methods => [:locations])
  end

  def send_text_message(message)
    return SMS_API.send_message(self.contact_number, message)
  end

end
