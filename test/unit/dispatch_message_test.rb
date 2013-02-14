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
#  efar_location_id         :integer
#



require 'test_helper'

class DispatchMessageTest < ActiveSupport::TestCase

  def setup
    @emergency = emergencies(:trill_road)
    @efar = efars(:buck)
    @efar_location = efar_locations(:trill_road)
    @efar_location.efar = @efar
    @efar_location.save

    @message = DispatchMessage.new
    @message.emergency = @emergency
    @message.efar = @efar
    @message.efar_location = @efar_location
    @message.save
  end

  test "deliver first text message" do
    @message.efar.expects(:send_text_message).returns({:status=>'success', :clickatell_id => '123'})
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

  test "find_most_active_for_number only returns a recent message" do
    assert_equal @message, DispatchMessage.find_most_active_for_number(@efar.contact_number)
    @message.created_at = 6.hours.ago
    @message.save
    assert_equal nil, DispatchMessage.find_most_active_for_number(@efar.contact_number), "should find no message"
  end

end
