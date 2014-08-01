# == Schema Information
#
# Table name: efars
#
#  id                  :integer          not null, primary key
#  full_name           :string(255)      not null
#  community_center_id :integer          not null
#  contact_number      :string(255)      not null
#  lat                 :float
#  lng                 :float
#  formatted_address   :string(255)
#  location_type       :string(255)
#  given_address       :string(255)
#  training_level      :string(255)      default("Basic")
#  training_date       :date
#  password_digest     :string(255)
#  study_invite_id     :integer
#  alert_subscriber    :boolean          default(FALSE)
#  dob                 :date
#  gender              :string(255)
#  occupation          :string(255)
#  certificate_number  :string(255)
#  module_1            :integer
#  module_2            :integer
#  module_3            :integer
#  module_4            :integer
#  cpr_competent       :boolean
#

# The efar table represents all efars willing to provide a mobile phone number
class Efar < ActiveRecord::Base

  # Individual Attributes
  attr_accessible :full_name, 
    :contact_number, 
    :community_center_id,
    :lat, :lng, :formatted_address, :location_type,
    :given_address,
    :training_level, :training_date,
    :password, :password_confirmation,
    :alert_subscriber,
    :dob, :gender, :occupation,
    :certificate_number, :module_4, :module_3, :module_2, :module_1, :cpr_competent

  PER_PAGE = 50
  TRAINING_LEVELS = ['Basic EFAR', 'Intermediate EFAR (FAL1)', 'Advanced EFAR (FAL3)',
    'Head Community Instructor', 'EMT', 'Paramedic']
  GENDERS = %w{Male Female}

  validates :full_name, :community_center_id, :contact_number, 
    :presence => true
  validates :contact_number, :uniqueness => true
  validates :given_address, :presence => true, :on => :create
  # validates :password, :on => :create, :presence => true

  belongs_to :community_center

  scope :active, where('training_date >= ? OR training_date IS NULL', 2.years.ago)
  scope :expired, where('training_date < ?', 2.years.ago)
  scope :alert_subscriber, where('alert_subscriber = ?', true)

  has_one :study_invite, :dependent => :destroy

  include Extensions::ContactNumber
  include Extensions::CapeTownLocation

  def self.all_for_page(page)  
    page ||= 0
    per_page = PER_PAGE

    return self.limit(per_page).offset(per_page*page).order('id DESC').all
  end
  
  def as_json(options = {})
    super(:methods => [:readable_contact_number])
  end


end
