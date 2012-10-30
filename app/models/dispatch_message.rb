class DispatchMessage < ActiveRecord::Base
  attr_accessible :efar_id, :emergency_id, :status
  belongs_to :efar
  belongs_to :emergency
end
