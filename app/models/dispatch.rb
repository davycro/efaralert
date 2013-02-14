# == Schema Information
#
# Table name: dispatches
#
#  id                    :integer          not null, primary key
#  dispatcher_id         :integer          not null
#  emergency_category    :string(255)
#  township_id           :integer
#  township_house_number :string(255)
#  landmarks             :string(255)
#  lat                   :float
#  lng                   :float
#  formatted_address     :string(255)
#  location_type         :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class Dispatch < ActiveRecord::Base
  attr_accessible :dispatcher_id, :emergency_category, 
    :landmarks, :township_id, :township_house_number, :formatted_address, :lat, 
    :lng, :location_type

  EMERGENCY_CATEGORIES = [
    'General emergency',
    'Uncontrolled bleed',
    'Motor vehicle accident',
    'Broken bone',
    'Unconscious person',
    'Fall from a height',
    'Seizure',
    'Burn',
    'Impaled object',
    'Shortness of breath',
    'Abdominal pain',
    'Confused person'
  ]
  
  validates :dispatcher_id, :presence => true

  belongs_to :dispatcher
  belongs_to :township

  validates :township_house_number, :township_id, :presence => true, :if => :nil_geolocation?
 
  def nil_geolocation?
    lng.blank? or lat.blank?
  end

  def has_geolocation?
    lng.present? and lat.present?
  end

  def readable_location
    return @readable_location if @readable_location.present?
    @readable_location = ""
    if township_id.present?
      @readable_location = "#{township_house_number} #{township.name}" 
    else
      @readable_location = "#{formatted_address}"
    end
    if landmarks.present?
      @readable_location += " (#{landmarks})"
    end
    return @readable_location
  end

  has_many :messages, :class_name=>"DispatchMessage", :dependent => :destroy

  after_create :create_messages
  after_create :log_new_dispatch

  def create_messages
    if has_geolocation?
      nearby_efar_locations.each do |location|
        dm = DispatchMessage.new
        dm.efar = location.efar
        dm.dispatch = self
        dm.efar_location = location
        dm.save
      end
    else
      nearby_efars.each do |efar|
        dm = DispatchMessage.new
        dm.efar = efar
        dm.dispatch = self
        dm.save
      end
    end
  end

  def log_new_dispatch
    ActivityLog.log "#{emergency_category} at #{readable_location}. #{self.nearby_efar_locations.size} efars notified."
  end

  def nearby_efar_locations
    @nearby_efar_locations ||= EfarLocation.near([self.lat, self.lng], 0.5).limit(10)
  end

  def nearby_efars
    return @nearby_efars unless @nearby_efars.blank?
    if has_geolocation?
      @nearby_efars = nearby_efar_locations.map(&:efar).compact.uniq
    else
      @nearby_efars = self.township.efars
    end
    return @nearby_efars
  end

  def head_efars
    @head_efars ||= self.messages.map(&:head_efars).flatten.uniq.compact
  end

  def alert_the_efars!
    self.messages.each { |m| m.deliver! }
  end

  def alert_the_head_efars!
    if messages.count>0

      # initiate the message text
      message = %/
        #{emergency_category} at #{readable_location}. 
        #{messages.count} people alerted: 
      /.squish

      # make list of names and contact numbers
      message += "\n"
      messages.map(&:efar).each do |efar|
        message += "#{efar.full_name} - #{efar.contact_number}\n"
      end

      # send message to every head efar
      head_efars.each do |head_efar|
        head_efar.send_text_message message
      end
    end
  end



end
