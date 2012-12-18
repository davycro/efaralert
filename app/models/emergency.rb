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

  # 
  # States
  #   possible emergency states
  #   key is stored in the database
  #   value is the message to output
  #   DO NOT CHANGE THESE KEYS!!!

  STATE_MESSAGES = {
    'new'                  => 'New',
    'sending'              => 'Sending',
    'sent'                 => 'Sent',
    'failed_no_airtime'    => 'Failed, no airtime',
    'no_efars_nearby'      => 'No efars nearby',
    'failed_unknown'       => 'Failed, reason unknown'
  }

  validates :state, :inclusion => { :in => STATE_MESSAGES.keys }

  belongs_to :dispatcher
  has_many :dispatch_messages, :dependent => :destroy
  has_many :sent_dispatch_messages, :class_name => "DispatchMessage",
    :conditions => {:state => %w(sent on_scene en_route)}
  has_many :en_route_dispatch_messages, :class_name => "DispatchMessage",
    :conditions => {:state => 'en_route'}
  has_many :on_scene_dispatch_messages, :class_name => "DispatchMessage",
    :conditions => {:state => 'on_scene'}
  has_many :failed_dispatch_messages, :class_name => "DispatchMessage",
    :conditions => { :state => 
      %w(failed) }



  before_validation :set_nil_state_to_new
  after_create :create_dispatch_messages

  def create_dispatch_messages
    nearby_efars.each do |efar|
      DispatchMessage.create(:efar_id => efar.id, :emergency_id => self.id)    
    end

    if self.dispatch_messages.count == 0
      self.state = 'no_efars_nearby'
      self.save
    end
  end

  def set_nil_state_to_new
    if self.state.blank? and self.new_record?
      self.state = 'new'
    end
  end

  def nearby_efars
    Efar.owns_mobile_phone.certified.near([self.lat, self.lng], 0.5).limit(10)  
  end

  def state_message
    STATE_MESSAGES[self.state]
  end

  def efar_ids
    @efar_ids ||= dispatch_messages.map(&:efar_id)
  end

  #
  # Needed for JSON

  def num_dispatch_messages
    dispatch_messages.count
  end

  def num_sent_dispatch_messages
    sent_dispatch_messages.count
  end

  def num_en_route_dispatch_messages
    en_route_dispatch_messages.count
  end

  def num_on_scene_dispatch_messages
    on_scene_dispatch_messages.count
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
      :num_en_route_dispatch_messages, :num_on_scene_dispatch_messages,
      :num_failed_dispatch_messages, :created_at_pretty, 
      :num_dispatch_messages])
  end

  def address_formatted_for_text_message
    # should only display the street
    formatted_address.split(",").first
  end

  def category_formatted_for_nil
    if @category.blank?
      @category = 'Emergency'
    end
    @category
  end

end
