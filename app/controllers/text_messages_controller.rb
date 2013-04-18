class TextMessagesController < InheritedResources::Base
  respond_to :json
  before_filter :require_dispatcher_login

  def index
    @text_messages = TextMessage.where("id > ? and created_at > ?", (params[:index] || 0), 6.hours.ago).all
    @text_messages.delete_if { |m| 
      Geocoder::Calculations.distance_between([m.efar.lat, m.efar.lng], [current_suburb.lat, current_suburb.lng], :units => :km) > 5
    }
    respond_with(@text_messages)
  end

  def create
    @text_message = TextMessage.new params[:text_message]
    @text_message.dispatcher_id = current_dispatcher.id
    @text_message.viewed_by_dispatcher = true
    @text_message.sender_class_name = 'Dispatcher'
    @text_message.sender_name = current_dispatcher.full_name
    if @text_message.save
      @text_message.deliver
    end

    respond_with @text_message
  end
end