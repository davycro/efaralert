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

require 'test_helper'

class DispatchMessageTest < ActiveSupport::TestCase

  def setup
    @dispatch = dispatches(:trill_road)
    @efar = efars(:trill_road)

    @message = DispatchMessage.new
    @message.dispatch = @dispatch
    @message.efar = @efar
    @message.save
  end

  def stub_efar_and_head_efars_to_expect_text_messages
    @message.efar.expects(:send_text_message).returns({:status=>'success'})
    @message.head_efars.each do |head_efar|
      head_efar.expects(:send_text_message).returns({:status=>'success'})
    end
  end

  test "deliver first text message" do
    @message.efar.expects(:send_text_message).returns({:status=>'success', :clickatell_id => '123'})
    response = @message.deliver!
    assert response[:status]=='success', "failed to send message: #{response.to_yaml}"
    assert @message.state=='sent'
  end

  test "reply help to any message" do
    stub_efar_and_head_efars_to_expect_text_messages
    @message.process_response "HELP"
  end

  test "find_most_active_for_number only returns a recent message" do
    assert_equal @message, DispatchMessage.find_most_active_for_number(@efar.contact_number)
    @message.created_at = 6.hours.ago
    @message.save
    assert_equal nil, DispatchMessage.find_most_active_for_number(@efar.contact_number), "should find no message"
  end

end
