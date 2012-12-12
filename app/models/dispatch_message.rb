# == Schema Information
#
# Table name: dispatch_messages
#
#  id            :integer          not null, primary key
#  emergency_id  :integer          not null
#  efar_id       :integer          not null
#  state         :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  clickatell_id :string(255)
#

class DispatchMessage < ActiveRecord::Base
  attr_accessible :efar_id, :emergency_id, :state, :clickatell_id
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
    'queued'   => 'Queued',
    'sending'  => 'Sending',
    'sent'     => 'Sent',
    'en_route' => 'En Route',
    'on_scene' => 'On Scene',
    'failed'   => 'Failed'
  }

  validates :state, :inclusion => { :in => STATE_MESSAGES.keys }
  before_validation :set_nil_state_to_queued

  def state_message
    STATE_MESSAGES[self.state]
  end

  def deliver!
    message = %/
      EFAR #{efar.full_name}, your help is needed! Emergency at  
      #{emergency.address_formatted_for_text_message}. Will you rescue? 
      Reply YES or NO 
      /.squish
    resp = SMS_API.send_message(efar.contact_number_formatted_for_clickatell, 
      message)
    if resp[:status] == 'success'
      self.state = 'sent'
      self.clickatell_id = resp[:clickatell_id]
    end
    if resp[:status] == 'failed'
      self.state = 'failed'
      self.clickatell_error_message = resp[:clickatell_error_message]
    end
    self.save
  end
  
end
