
require 'test_helper'

class TownshipDispatchMessageTest < ActiveSupport::TestCase

  def setup
    @dispatch = dispatches(:overcome)
    @efar = efars(:buck)
    @efar.township = @dispatch.township
    @efar.save

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

  test "reply yes to sent message" do
    # setup
    @message.state = 'sent'
    #
    # stub efar and head efar
    @message.efar.expects(:send_text_message).returns({:status=>'success'})
    @message.head_efars.each do |head_efar|
      head_efar.expects(:send_text_message).returns({:status=>'success'})
    end
    
    @message.process_response "YeS"
    assert @message.state=='en_route'
  end

  test "reply yes to en_route message" do
    # setup
    @message.state = 'en_route'
    #
    # stub efar and head efar
    @message.efar.expects(:send_text_message).returns({:status=>'success'})
    @message.head_efars.each do |head_efar|
      head_efar.expects(:send_text_message).returns({:status=>'success'})
    end
    
    @message.process_response "YeS"
    assert @message.state=='on_scene'
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
