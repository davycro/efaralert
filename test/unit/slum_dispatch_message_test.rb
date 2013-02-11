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

require 'test_helper'

class SlumDispatchMessageTest < ActiveSupport::TestCase

  def setup
    @emergency = slum_emergencies(:overcome)
    @efar = efars(:buck)
    @efar.slum = @emergency.slum
    @efar.save 

    @message = SlumDispatchMessage.new
    @message.slum_emergency = @emergency
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

  test "find_most_active_for_number only returns a recent message" do
    assert_equal @message, SlumDispatchMessage.find_most_active_for_number(@efar.contact_number)
    @message.created_at = 6.hours.ago
    @message.save
    assert_equal nil, SlumDispatchMessage.find_most_active_for_number(@efar.contact_number), "should find no message"
  end


end
