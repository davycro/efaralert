# == Schema Information
#
# Table name: text_messages
#
#  id                   :integer          not null, primary key
#  efar_id              :integer          not null
#  dispatcher_id        :integer
#  content              :text
#  viewed_by_dispatcher :boolean          default(FALSE)
#  sender_name          :string(255)
#  sender_class_name    :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class TextMessage < ActiveRecord::Base
  attr_accessible :content, 
    :dispatcher_id, :efar_id, 
    :sender_class_name, :sender_name, 
    :viewed_by_dispatcher

  validates :efar_id, :sender_class_name,
    :presence => true

  belongs_to :efar
  belongs_to :dispatcher

  def readable_time
    self.updated_at.strftime("%Hh%M")  
  end

  def as_json(options={})
    super(:methods => [:readable_time])
  end

  def deliver
    if sender_class_name=='Dispatcher'
      message = self.content
      message += ". From #{self.dispatcher.full_name} (Metro EMS)"
      self.efar.send_text_message(self.content)
    end
  end

end
