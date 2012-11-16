class DispatchMessage < ActiveRecord::Base
  attr_accessible :efar_id, :emergency_id, :status
  belongs_to :efar
  belongs_to :emergency

  def lat
    self.efar.lat
  end

  def lng
    self.efar.lng
  end
  
end
