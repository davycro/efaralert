# == Schema Information
#
# Table name: emergencies
#
#  id                :integer          not null, primary key
#  dispatcher_id     :integer          not null
#  input_address     :string(255)      not null
#  category          :string(255)
#  state             :string(255)
#  formatted_address :string(255)
#  lat               :float            not null
#  lng               :float            not null
#  location_type     :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Emergency < ActiveRecord::Base
  attr_accessible :input_address, :dispatcher_id, :category, :formatted_address, 
    :lat, :lng, :location_type, :state

  validates :input_address, :dispatcher_id,
    :presence => true

  belongs_to :dispatcher
  has_many :dispatch_messages, :dependent => :destroy
  has_many :sent_dispatch_messages, :class_name => "DispatchMessage",
    :conditions => {:state => %w(sent responding declined)}
  has_many :responding_dispatch_messages, :class_name => "DispatchMessage",
    :conditions => {:state => 'responding'}
  has_many :declined_dispatch_messages, :class_name => "DispatchMessage",
    :conditions => {:state => 'declined'}
  has_many :failed_dispatch_messages, :class_name => "DispatchMessage",
    :conditions => { :state => 
      %w(failed) }

  after_create :create_dispatch_messages

  def create_dispatch_messages
    nearby_efars.each do |efar|
      DispatchMessage.create(:efar_id => efar.id, :emergency_id => self.id)    
    end
  end

  def nearby_efars
    Efar.near([self.lat, self.lng], 0.5).limit(10)  
  end

  #
  # Needed for JSON

  def efar_ids
    @efar_ids ||= dispatch_messages.map(&:efar_id)
  end

  def num_dispatch_messages
    dispatch_messages.count
  end

  def num_sent_dispatch_messages
    sent_dispatch_messages.count
  end

  def num_responding_dispatch_messages
    responding_dispatch_messages.count
  end

  def num_declined_dispatch_messages
    declined_dispatch_messages.count
  end

  def num_failed_dispatch_messages
    failed_dispatch_messages.count
  end

  def created_at_pretty
    self.created_at.in_time_zone("Africa/Johannesburg").
      strftime("%I:%M %p - %d %b %y")
  end

  def as_json(options = {})
    super(:methods => [:efar_ids, :num_sent_dispatch_messages, 
      :num_responding_dispatch_messages, :num_declined_dispatch_messages,
      :num_failed_dispatch_messages, :created_at_pretty, 
      :num_dispatch_messages])
  end

  def address_formatted_for_text_message
    # should only display the street
    formatted_address.split(",").first
  end

  def category_formatted_for_nil
    if self.category.blank?
      self.category = 'Emergency'
    end
    self.category
  end

  def dispatch_efars!
    self.dispatch_messages.each { |m| m.deliver! }
  end

  def dispatch_head_efars!
    if sent_dispatch_messages.count>0
      ## Compose message to the head efars
      # find head efars
      head_efars = sent_dispatch_messages.map(&:efar).map(&:head_efars).uniq.compact
      if head_efars.blank?
        return false
      end
      # initiate the message text
      message = %/
        #{self.category_formatted_for_nil} at #{self.address_formatted_for_text_message}. #{sent_dispatch_messages.count} people alerted:
      /.squish

      # make list of names and contact numbers
      message += "\n"
      sent_dispatch_messages.map(&:efar).each do |efar|
        message += "#{efar.full_name} - #{efar.contact_number}\n"
      end

      # send message to every head efar
      head_efars.each do |head_efar|
        SMS_API.send_message(head_efar.contact_number, message)
      end
    end

  end

end
