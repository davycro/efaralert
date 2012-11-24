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
    'failed_unknown_error' => 'Failed, reason unknown'
  }

  validates :state, :inclusion => { :in => STATE_MESSAGES.keys }

  belongs_to :dispatcher
  has_many :dispatch_messages, :dependent => :destroy

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

  def num_efars_notified
    @num_efars_notified ||= dispatch_messages.count  
  end
  
  def num_pending_messages
    @num_pending_messages ||= self.dispatch_messages.where(:status => nil).count
  end

  def num_failed_messages
    @num_failed_messages ||= self.dispatch_messages.where(:status => "failed").count
  end

  def efar_ids
    @efar_ids ||= dispatch_messages.map(&:efar_id)
  end

  # hack for displaying time in pretty format

  def timezone
    "Mountain Time (US & Canada)"
  end

  def formatted_created_at_time
    # 20h43
    self.created_at.in_time_zone(timezone).strftime("%Hh%M")
  end

  def formatted_created_at_date
    # 19-Oct-12
    self.created_at.in_time_zone(timezone).strftime("%d %b %Y")
  end

end
