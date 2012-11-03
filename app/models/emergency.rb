class Emergency < ActiveRecord::Base
  attr_accessible :input_address, :dispatcher_id, :category, :formatted_address, 
    :lat, :lng, :location_type

  validates :input_address, :dispatcher_id,
    :presence => true

  belongs_to :dispatcher
  has_many :dispatch_messages

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
    dispatch_messages.count  
  end
  
  def efar_ids
    @efar_ids ||= dispatch_messages.map(&:efar_id)
  end

end
