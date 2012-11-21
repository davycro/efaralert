class Emergency < ActiveRecord::Base
  attr_accessible :input_address, :dispatcher_id, :category, :formatted_address, 
    :lat, :lng, :location_type

  validates :input_address, :dispatcher_id,
    :presence => true

  belongs_to :dispatcher
  has_many :dispatch_messages, :dependent => :destroy

  after_create :create_dispatch_messages

  def create_dispatch_messages
    nearby_efars.each do |efar|
      DispatchMessage.create(:efar_id => efar.id, :emergency_id => self.id)    
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


  def dispatch_status
    if num_efars_notified==0
      return "No efars near the emergency"
    end
    if num_pending_messages > 0
      return "Sending messages to #{num_pending_messages} efars"
    end
    if num_failed_messages==num_efars_notified
      return "Failed to send messages"
    end
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
