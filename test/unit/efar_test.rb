# == Schema Information
#
# Table name: efars
#
#  id                  :integer          not null, primary key
#  full_name           :string(255)      not null
#  community_center_id :integer          not null
#  slum_id             :integer
#  contact_number      :string(255)      not null
#

require 'test_helper'

class EfarTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "has many locations" do
    david = efars(:david)
    assert david.locations.present?
  end

  test "can send a text message" do
    david = efars(:david)
    response = david.send_text_message "hello, this is just a test"
    assert response[:status]=='success'
  end
end
