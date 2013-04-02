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

  include Extensions::CapeTownLocation
  include Extensions::ReadableTimestamps
  
  validates :dispatcher_id, :presence => true

  belongs_to :dispatcher
  belongs_to :township

  has_many :messages, :class_name=>"DispatchMessage", :dependent => :destroy

  after_create :create_messages
  after_create :log_new_dispatch

  def create_messages
    nearby_efars.each do |efar|
      dm = DispatchMessage.new
      dm.efar = efar
      dm.dispatch = self
      dm.save
    end
  end

  def log_new_dispatch
    ActivityLog.log "#{emergency_category} at #{readable_location}. #{self.nearby_efars.size} efars notified."
  end

  def nearby_efars
    return @nearby_efars unless @nearby_efars.blank?
    if has_geolocation?
      @nearby_efars = Efar.near([self.lat, self.lng], 0.3, :order => 'distance')
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

  def message_stats
    { 'sent' => messages.sent.count,
      'failed' => messages.failed.count,
      'queued' => messages.queued.count,
      'total' => messages.count }
  end

  def as_json(options = {})
    super(:methods => [:readable_location, :message_stats, :readable_timestamps])
  end

  def logged_at_in_cape_town_time_zone
    self.created_at.in_time_zone("Africa/Johannesburg").
      strftime("%I:%M %p - %d %b %y")
  end

end
