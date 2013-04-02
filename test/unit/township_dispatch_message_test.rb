
require 'test_helper'

class TownshipDispatchMessageTest < ActiveSupport::TestCase

  def setup
    @dispatch = dispatches(:overcome)
    @efar = efars(:buck)
    @efar.update_attribute :township_id, @dispatch.township.id

    @message = DispatchMessage.new
    @message.dispatch = @dispatch
    @message.efar = @efar
    @message.save
  end

  test "deliver first text message" do
    response = @message.deliver!
    assert response[:status]=='success', "failed to send message: #{response.to_yaml}"
    assert @message.state=='sent'
  end

  test "reply help to any message" do
    #
    # stub efar and head efar
    @message.efar.expects(:send_text_message).returns({:status=>'success'})
    @message.head_efars.each do |head_efar|
      head_efar.expects(:send_text_message).returns({:status=>'success'})
    end
    
    @message.process_response "HELP"
  end

end
