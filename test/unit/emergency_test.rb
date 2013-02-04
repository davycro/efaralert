# == Schema Information
#
# Table name: emergencies
#
#  id                :integer          not null, primary key
#  dispatcher_id     :integer          not null
#  input_address     :string(255)      not null
#  category          :string(255)
#  state             :string(255)
#  formatted_address :string(255)
#  lat               :float            not null
#  lng               :float            not null
#  location_type     :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'test_helper'

class EmergencyTest < ActiveSupport::TestCase
  
  # Replace this with your real tests.
  test "should find nearby efar locations" do
    trill_road = efar_locations(:trill_road)
    broken_bone = Emergency.new(lat: trill_road.lat, lng: trill_road.lng)
    nearby_efar_locations = broken_bone.nearby_efar_locations
    assert nearby_efar_locations.include?(trill_road)
    assert nearby_efar_locations.include?(efar_locations(:herschel_road))
    assert_equal broken_bone.nearby_efars, [efars(:david)]
  end
end
