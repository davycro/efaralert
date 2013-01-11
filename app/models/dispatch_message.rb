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
    'queued'     => 'Queued',
    'sending'    => 'Sending',
    'sent'       => 'Sent',
    'responding' => 'Responding',
    'declined'   => 'Declined',
    'failed'     => 'Failed'
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
    text = text.downcase
    if text.downcase=='help'
      self.send_help_message_to_efar_and_head_efar
      return true
    end
    if self.state=='sent'
      if text=='yes' or text=='y' or text=='ye'
        self.state='responding'
        self.save
        self.send_responding_message_to_efar_and_head_efar
      end
      if text=='no' or text=='n'
        self.state='declined'
        self.save
        self.send_declined_message_to_efar_and_head_efar
      end
      return true
    end
    return false
  end

  def send_help_message_to_efar_and_head_efar
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
    self.efar.head_efars.each do |head_efar|
      SMS_API.send_message(head_efar.contact_number, 
        message_for_head_efar)
    end
  end

  def send_responding_message_to_efar_and_head_efar
    Rails.logger.info "Sending RESPONDING Message"

    message = %/
      Thank you for responding. Reply HELP if you need assistance
    /.squish
    self.send_message_to_efar(message)

    message_for_head_efar = %/
      #{efar.full_name} responding to emergency at #{emergency.address_formatted_for_text_message}. Their contact number is: #{efar.contact_number}
    /.squish
    self.efar.head_efars.each do |head_efar|
      SMS_API.send_message(head_efar.contact_number, message_for_head_efar)
    end
  end

  def send_declined_message_to_efar_and_head_efar
    # nil, this is a todo item
  end

  def deliver!
    message = %/
      EFAR #{efar.full_name}, your help is needed! 
      #{emergency.category_formatted_for_nil} at  
      #{emergency.address_formatted_for_text_message}. Will you rescue? Reply YES when you arrive at the accident, or reply NO if you cannot help.
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
