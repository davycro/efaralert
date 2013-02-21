# == Schema Information
#
# Table name: efars
#
#  id                    :integer          not null, primary key
#  full_name             :string(255)      not null
#  community_center_id   :integer          not null
#  contact_number        :string(255)      not null
#  township_id           :integer
#  township_house_number :string(255)
#  lat                   :float
#  lng                   :float
#  formatted_address     :string(255)
#  location_type         :string(255)
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

  test "can format contact_number" do
    david = efars(:david)
    unformatted_num = "123456789"
    formatted_num = "27" + unformatted_num
    david.contact_number = unformatted_num
    david.format_contact_number
    assert david.contact_number==formatted_num

    unformatted_num = "0" + unformatted_num
    david.contact_number = unformatted_num
    david.format_contact_number
    assert david.contact_number==formatted_num

    david.format_contact_number
    assert david.contact_number==formatted_num
  end
end
