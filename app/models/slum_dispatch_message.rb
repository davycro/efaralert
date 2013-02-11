# == Schema Information
#
# Table name: slum_dispatch_messages
#
#  id                       :integer          not null, primary key
#  slum_emergency_id        :integer          not null
#  efar_id                  :integer          not null
#  clickatell_error_message :string(255)
#  state                    :string(255)      default("queued")
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

class SlumDispatchMessage < ActiveRecord::Base
  attr_accessible :clickatell_error_message, :efar_id, :slum_emergency_id, :state

  STATE_MESSAGES = %w(queued sent en_route on_scene declined failed)
  validates :state, :inclusion => { :in => STATE_MESSAGES }

  belongs_to :efar
  belongs_to :slum_emergency

  def head_efars
    @head_efars ||= self.efar.head_efars
  end

  def address
    "#{slum_emergency.formatted_address}"
  end

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
    ActivityLog.log "#{self.efar.full_name} needs help at #{self.address}, proceeding to dispatch head efars"

    message = %/
      Ok, someone will call to assist you immediately
    /.squish
    self.efar.send_text_message(message)

    message_for_head_efar = %/
      EFAR #{self.efar.full_name} needs your help at 
      #{self.address}! Please call them at 
      #{self.efar.contact_number}
    /.squish
    self.head_efars.each do |head_efar|
      head_efar.send_text_message message_for_head_efar
    end
  end

  # state change: sent -> en route
  def set_state_to_en_route_and_then_send_messages
    ActivityLog.log "#{self.efar.full_name} is en route to emergency at #{address}"

    self.state='en_route'
    self.save

    message = %/
      Thank you! We alerted your head EFAR that you are on the way. Reply YES when you arrive at the emergency. Reply HELP if you need help.
    /.squish
    self.efar.send_text_message(message)

    message_for_head_efar = %/
      #{efar.full_name} en route to emergency at #{address}. Their contact number is: #{efar.contact_number}
    /.squish
    self.head_efars.each do |head_efar|
      head_efar.send_text_message message_for_head_efar
    end
  end

  # state change: en route -> on scene
  def set_state_to_on_scene_and_then_send_messages
    ActivityLog.log "#{self.efar.full_name} arrived at emergency at #{address}"

    self.state='on_scene'
    self.save

    message = %/
      Thank you! We alerted your head EFAR that you are at the emergency. Reply HELP if you need help. An ambulance will meet you soon.
    /.squish
    self.efar.send_text_message(message)

    message_for_head_efar = %/
      #{efar.full_name} ON SCENE at #{address}. Their contact number is: #{efar.contact_number}
    /.squish
    self.head_efars.each do |head_efar|
      head_efar.send_text_message message_for_head_efar
    end
  end

  # state change: ? -> declined
  def set_state_to_declined_and_then_send_messages
    ActivityLog.log "#{self.efar.full_name} declined to respond to emergency at #{address}"

    self.state='declined'
    self.save

    message = %/
      Okay. Hopefully another efar can respond for you.
    /.squish
    self.efar.send_text_message(message)

    message_for_head_efar = %/
      #{efar.full_name} DECLINED to respond to emergency at 
      #{address}. 
      Their contact number is: #{efar.contact_number}
    /.squish
    self.head_efars.each do |head_efar|
      head_efar.send_text_message message_for_head_efar
    end
  end

  def deliver!
    message = %/
      EFAR #{efar.full_name}, your help is urgently needed! 
      #{slum_emergency.category_formatted_for_nil} at  
      #{address}. 
      Will you rescue right now!? Reply YES or NO
      /.squish
    resp = self.efar.send_text_message(message)
    if resp[:status] == 'success'
      self.state = 'sent'
    end
    if resp[:status] == 'failed'
      self.state = 'failed'
      self.clickatell_error_message = resp[:clickatell_error_message]
    end
    self.save!
    return resp
  end

  def self.find_most_active_for_number(contact_number)
    efar = Efar.find_by_contact_number contact_number
    return nil if efar.blank?
    dispatch_message = efar.slum_dispatch_messages.
      where("created_at >= :start_date", { :start_date => 2.hours.ago }).
      order('created_at DESC').first
    return dispatch_message
  end

end
