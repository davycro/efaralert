# == Schema Information
#
# Table name: dispatch_messages
#
#  id                       :integer          not null, primary key
#  efar_id                  :integer          not null
#  state                    :string(255)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  clickatell_id            :string(255)
#  clickatell_error_message :string(255)
#  dispatch_id              :integer          not null
#

class DispatchMessage < ActiveRecord::Base

  STATE_MESSAGES = {
    'queued'     => 'Queued',
    'sending'    => 'Sending',
    'sent'       => 'Sent',
    'en_route'   => 'En route',
    'on_scene'   => 'On scene',
    'declined'   => 'Declined',
    'failed'     => 'Failed'
  }

  attr_accessible :efar_id, :emergency_id, :state, :clickatell_id

  before_validation :set_nil_state_to_queued
  validates :state, :inclusion => { :in => STATE_MESSAGES.keys }

  #
  # Attribute shortcuts

  belongs_to :efar
  belongs_to :dispatch

  #
  # Scopes
  scope :sent, where(:state => %w(sent en_route on_scene declined))
  STATE_MESSAGES.keys.each do |state_name|
    unless state_name=='sent'
      scope state_name.to_sym, where(:state => state_name)
    end
  end

  def head_efars
    self.efar.head_efars
  end

  def readable_location
    dispatch.readable_location  
  end

  #
  # Validation Callbacks

  def set_nil_state_to_queued
    if self.state.blank? and self.new_record?
      self.state = 'queued'
    end
  end

  #
  # Methods that take action based on received text messages

  def process_response(text)
    text = text.downcase
    if text=='help'
      return send_help_messages
    end
    if self.state=='sent'
      if text=='yes' or text=='y' or text=='ye'
        return set_state_to_en_route_and_then_send_messages
      end
      if text=='no' or text=='n'
        return set_state_to_declined_and_then_send_messages
      end
    end
    if self.state=='en_route'
      if text=='yes' or text=='ye' or text=='y'
        return set_state_to_on_scene_and_then_send_messages
      end
      if text=='no' or text=='n'
        return set_state_to_declined_and_then_send_messages
      end
    end
    return false
  end

  def send_help_messages
    ActivityLog.log "#{self.efar.full_name} needs help, proceeding to dispatch head efars"

    message = %/
      Ok, someone will call to assist you immediately
    /.squish
    self.efar.send_text_message(message)

    message_for_head_efar = %/
      EFAR #{self.efar.full_name} needs your help at 
      #{readable_location}! Please call them at 
      #{self.efar.contact_number}
    /.squish
    self.head_efars.each do |head_efar|
      head_efar.send_text_message message_for_head_efar
    end
  end

  # state change: sent -> en route
  def set_state_to_en_route_and_then_send_messages
    ActivityLog.log "#{self.efar.full_name} is en route to emergency at #{readable_location}"

    self.state='en_route'
    self.save

    message = %/
      Thank you! We alerted your head EFAR that you are on the way. Reply YES when you arrive at the emergency. Reply HELP if you need help.
    /.squish
    self.efar.send_text_message(message)

    message_for_head_efar = %/
      #{efar.full_name} en route to emergency at #{readable_location}. Their contact number is: #{efar.contact_number}
    /.squish
    self.head_efars.each do |head_efar|
      head_efar.send_text_message message_for_head_efar
    end
  end

  # state change: en route -> on scene
  def set_state_to_on_scene_and_then_send_messages
    ActivityLog.log "#{self.efar.full_name} arrived at emergency at #{readable_location}"

    self.state='on_scene'
    self.save

    message = %/
      Thank you! We alerted your head EFAR that you are at the emergency. Reply HELP if you need help. An ambulance will meet you soon.
    /.squish
    self.efar.send_text_message(message)

    message_for_head_efar = %/
      #{efar.full_name} ON SCENE at #{readable_location}. Their contact number is: #{efar.contact_number}
    /.squish
    self.head_efars.each do |head_efar|
      head_efar.send_text_message message_for_head_efar
    end
  end

  # state change: ? -> declined
  def set_state_to_declined_and_then_send_messages
    ActivityLog.log "#{self.efar.full_name} declined to respond to emergency at #{readable_location}"

    self.state='declined'
    self.save

    message = %/
      Okay. Hopefully another efar can respond for you.
    /.squish
    self.efar.send_text_message(message)

    message_for_head_efar = %/
      #{efar.full_name} DECLINED to respond to emergency at 
      #{readable_location}. 
      Their contact number is: #{efar.contact_number}
    /.squish
    self.head_efars.each do |head_efar|
      head_efar.send_text_message message_for_head_efar
    end
  end

  def deliver!
    message = %/
      EFAR #{efar.full_name}, your help is urgently needed! 
      #{dispatch.emergency_category} at  
      #{readable_location}. 
      Will you rescue? Reply YES or NO
      /.squish
    resp = self.efar.send_text_message(message)
    if resp[:status] == 'success'
      self.state = 'sent'
      self.clickatell_id = resp[:clickatell_id]
    end
    if resp[:status] == 'failed'
      self.state = 'failed'
      self.clickatell_error_message = resp[:clickatell_error_message]
    end
    self.save!
    return resp
  end

  def as_json(options = {})
    super(:methods => [:efar])
  end

  def self.find_most_active_for_number(contact_number)
    efar = Efar.find_by_contact_number contact_number
    return nil if efar.blank?
    dispatch_message = efar.dispatch_messages.
      where("created_at >= :start_date", { :start_date => 2.hours.ago }).
      order('created_at DESC').first
    return dispatch_message

  end
  
end
