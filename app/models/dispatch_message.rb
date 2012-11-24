# == Schema Information
#
# Table name: dispatch_messages
#
#  id           :integer          not null, primary key
#  emergency_id :integer          not null
#  efar_id      :integer          not null
#  state        :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class DispatchMessage < ActiveRecord::Base
  attr_accessible :efar_id, :emergency_id, :state
  belongs_to :efar
  belongs_to :emergency

  def lat
    self.efar.lat
  end

  def lng
    self.efar.lng
  end

  #
  # Callbacks

  def set_nil_state_to_queued
    if self.state.blank? and self.new_record?
      self.state = 'queued'
    end
  end

  STATE_MESSAGES = {
    'queued'                        => 'Queued',
    'sending'                       => 'Sending',
    'sent'                          => 'Sent',
    'en_route'                      => 'En Route',
    'on_scene'                      => 'On Scene',
    'failed_invalid_contact_number' => 'Failed, invalid contact number',
    'failed_no_airtime'             => 'Failed, no airtime',
    'failed_unknown'                => 'Failed, reason unknown'
  }

  validates :state, :inclusion => { :in => STATE_MESSAGES.keys }
  before_validation :set_nil_state_to_queued
  
end
