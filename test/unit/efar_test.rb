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

  test "null cpr_competent equals competent" do
    david = efars(:david)
    david.cpr_competent = nil
    assert !david.not_competent? 
  end

  test "low module score equals not competent" do
    david = efars(:david)
    david.module_4 = 1
    david.module_3 = 1
    david.module_2 = 1
    david.module_1 = 1
    david.cpr_competent = true
    assert david.not_competent?
  end

    test "high module score equals not competent" do
    david = efars(:david)
    david.module_4 = 10
    david.module_3 = 10
    david.module_2 = 10
    david.module_1 = 1
    david.cpr_competent = true
    assert !david.not_competent?
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
