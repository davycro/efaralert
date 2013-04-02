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
    'failed'     => 'Failed'
  }

  attr_accessible :efar_id, :emergency_id, :state, :clickatell_id

  before_validation :set_nil_state_to_queued
  validates :state, :inclusion => { :in => STATE_MESSAGES.keys }

  include Extensions::ReadableTimestamps

  #
  # Attribute shortcuts

  belongs_to :efar
  belongs_to :dispatch

  #
  # Scopes
  # sent is a special case that includes legacy states "on_scene" and "declined"
  
  scope :sent, where(:state => %w(sent on_scene declined))
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
    if text[0..6].include?('help')
      return send_help_messages
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

  def deliver!
    message = %/
      EFAR #{efar.full_name}, your help is urgently needed! 
      #{dispatch.emergency_category} at  
      #{readable_location}.
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
    super(:methods => [:efar, :readable_timestamps])
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
