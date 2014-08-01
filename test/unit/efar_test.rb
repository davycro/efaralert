# == Schema Information
#
# Table name: efars
#
#  id                  :integer          not null, primary key
#  full_name           :string(255)      not null
#  community_center_id :integer          not null
#  contact_number      :string(255)      not null
#  lat                 :float
#  lng                 :float
#  formatted_address   :string(255)
#  location_type       :string(255)
#  given_address       :string(255)
#  training_level      :string(255)      default("Basic")
#  training_date       :date
#  password_digest     :string(255)
#  study_invite_id     :integer
#  alert_subscriber    :boolean          default(FALSE)
#  dob                 :date
#  gender              :string(255)
#  occupation          :string(255)
#  certificate_number  :string(255)
#  module_1            :integer
#  module_2            :integer
#  module_3            :integer
#  module_4            :integer
#  cpr_competent       :boolean
#

require 'test_helper'

class EfarTest < ActiveSupport::TestCase
  # Replace this with your real tests.

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
    david.format_contact_number_for_south_africa
    assert david.contact_number==formatted_num

    unformatted_num = "0" + unformatted_num
    david.contact_number = unformatted_num
    david.format_contact_number_for_south_africa
    assert david.contact_number==formatted_num

    david.format_contact_number_for_south_africa
    assert david.contact_number==formatted_num
  end
end
