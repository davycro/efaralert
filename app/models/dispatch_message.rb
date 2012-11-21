# == Schema Information
#
# Table name: dispatch_messages
#
#  id           :integer          not null, primary key
#  emergency_id :integer          not null
#  efar_id      :integer          not null
#  status       :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

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
