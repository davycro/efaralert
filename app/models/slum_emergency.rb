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
#

class SlumEmergency < ActiveRecord::Base
  attr_accessible :category, :dispatcher_id, :shack_number, :slum_id

  validates :shack_number, :dispatcher_id, :slum_id, :presence => true

  belongs_to :dispatcher
  belongs_to :slum

  has_many :slum_dispatch_messages, :dependent => :destroy
  has_many :sent_slum_dispatch_messages, :class_name => "SlumDispatchMessage",
    :conditions => {:state => %w(sent en_route on_scene declined)}

  after_create :create_dispatch_messages

  def create_dispatch_messages
    self.slum.efars.each do |efar|
      dm = SlumDispatchMessage.new
      dm.efar = efar
      dm.slum_emergency = self
      dm.save
    end
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

  def dispatch_head_efars!
    if slum_dispatch_messages.count>0

      # initiate the message text
      message = %/
        #{category_formatted_for_nil} at #{formatted_address}. 
        #{sent_slum_dispatch_messages.count} people alerted: 
      /.squish

      # make list of names and contact numbers
      message += "\n"
      sent_slum_dispatch_messages.map(&:efar).each do |efar|
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
