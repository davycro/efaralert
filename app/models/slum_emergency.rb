# == Schema Information
#
# Table name: slum_emergencies
#
#  id            :integer          not null, primary key
#  slum_id       :integer          not null
#  category      :string(255)
#  shack_number  :string(255)
#  dispatcher_id :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  landmarks     :string(255)
#

class SlumEmergency < ActiveRecord::Base
  attr_accessible :category, :dispatcher_id, :shack_number, :slum_id, :landmarks

  validates :shack_number, :dispatcher_id, :slum_id, :presence => true

  belongs_to :dispatcher
  belongs_to :slum

  has_many :slum_dispatch_messages, :dependent => :destroy
  has_many :sent_dispatch_messages, :class_name => "SlumDispatchMessage",
    :conditions => {:state => %w(sent en_route on_scene declined)}

  %w(en_route on_scene declined failed).each do |dispatch_message_state_name|
    has_many "#{dispatch_message_state_name}_dispatch_messages".to_sym,
      :class_name => "SlumDispatchMessage", 
      :conditions => { :state => dispatch_message_state_name }
  end

  after_create :create_dispatch_messages
  after_create :log_new_emergency

  def create_dispatch_messages
    self.slum.efars.each do |efar|
      dm = SlumDispatchMessage.new
      dm.efar = efar
      dm.slum_emergency = self
      dm.save
    end
  end

  def log_new_emergency
    ActivityLog.log "Emergency at #{formatted_address}. Category: #{@category}. #{self.slum.efars.size} efars notified."
  end

  def dispatch_efars!
    self.slum_dispatch_messages.each { |m| m.deliver! }
  end

  def head_efars
    @head_efars ||= self.slum_dispatch_messages.map(&:head_efars).flatten.uniq.compact
  end

  def formatted_address
    "#{shack_number} #{slum.name}"
  end

  def readable_location
    return @loc if @loc.present?
    @loc = ""
    @loc = formatted_address
    if landmarks.present?
      @loc += " (#{landmarks})"
    end
    return @loc
  end

  def dispatch_head_efars!
    if slum_dispatch_messages.count>0

      # initiate the message text
      message = %/
        #{category_formatted_for_nil} at #{formatted_address}. 
        #{slum_dispatch_messages.count} people alerted: 
      /.squish

      # make list of names and contact numbers
      message += "\n"
      slum_dispatch_messages.map(&:efar).each do |efar|
        message += "#{efar.full_name} - #{efar.contact_number}\n"
      end

      # send message to every head efar
      head_efars.each do |head_efar|
        head_efar.send_text_message message
      end
    end
  end

  def category_formatted_for_nil
    if self.category.blank?
      self.category = 'Emergency'
    end
    self.category
  end

end
