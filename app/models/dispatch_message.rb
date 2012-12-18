# == Schema Information
#
# Table name: dispatch_messages
#
#  id                       :integer          not null, primary key
#  emergency_id             :integer          not null
#  efar_id                  :integer          not null
#  state                    :string(255)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  clickatell_id            :string(255)
#  clickatell_error_message :string(255)
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
    if self.state=='failed'
      return "Failed, #{self.clickatell_error_message}"
    else
      return STATE_MESSAGES[self.state]
    end
  end

  def process_response(text)
    if text.downcase=='help'
      self.send_help_message
      return true
    end
    if self.state=='sent'
      self.state='en_route'
      self.save
      self.send_en_route_message
      return true
    end
    if self.state=='en_route'
      self.state='on_scene'
      self.save
      self.send_on_scene_message
      return true
    end
    return false
  end

  def send_help_message
    Rails.logger.info "Sending Help Message"

    message = %/
      Ok, someone will call to assist you immediately
    /.squish
    self.send_message_to_efar(message)

    message_for_head_efar = %/
      EFAR #{self.efar.full_name} needs your help at 
      #{emergency.address_formatted_for_text_message}! Please call them at 
      #{self.efar.contact_number}
    /.squish
    SMS_API.send_message(self.efar.head_efar.contact_number, 
      message_for_head_efar)
  end

  def send_on_scene_message
    Rails.logger.info "Sending ON SCENE Message"

    message = %/
      Thank you for responding. Reply HELP if you need assistance
    /.squish
    self.send_message_to_efar(message)
  end

  def send_en_route_message
    Rails.logger.info "Sending EN ROUTE Message"

    message = %/
      Thank you! Reply YES when you arrive at the emergency. Reply HELP if you 
      need assistance.
    /.squish
    self.send_message_to_efar(message)
  end

  def deliver!
    message = %/
      EFAR #{efar.full_name}, your help is needed! 
      #{emergency.category_formatted_for_nil} at  
      #{emergency.address_formatted_for_text_message}. Will you rescue? 
      Reply YES or ignore 
      /.squish
    resp = self.send_message_to_efar(message)

    if resp[:status] == 'success'
      self.state = 'sent'
      self.clickatell_id = resp[:clickatell_id]
    end
    if resp[:status] == 'failed'
      self.state = 'failed'
      self.clickatell_error_message = resp[:clickatell_error_message]
    end
    self.save!
  end

  def send_message_to_efar(message)
    return SMS_API.send_message(efar.contact_number_formatted_for_clickatell,
      message)
  end

  def as_json(options = {})
    super(:methods => [:efar, :lat, :lng])
  end
  
end
