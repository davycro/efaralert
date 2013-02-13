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
#  landmarks         :string(255)
#

require 'test_helper'

class EmergencyTest < ActiveSupport::TestCase
  
  def initialize_emergency_at_trill_road
    trill_road = efar_locations(:trill_road)
    emergency = Emergency.new(lat: trill_road.lat,
      lng: trill_road.lng,
      dispatcher_id: 1,
      input_address: "50 trill road, cape town")
    return emergency  
  end

  test "should find nearby efar locations" do
    broken_bone = initialize_emergency_at_trill_road
    nearby_efar_locations = broken_bone.nearby_efar_locations
    assert nearby_efar_locations.include?(efar_locations(:trill_road))
    assert nearby_efar_locations.include?(efar_locations(:herschel_road))
  end

  test "should create dispatch messages" do
    emergency = initialize_emergency_at_trill_road
    assert emergency.save, "Emergency did not save: #{emergency.to_yaml}"
    emergency = Emergency.find(emergency.id)
    assert emergency.dispatch_messages.present?, "No dispatch messages created"
    assert emergency.dispatch_messages.detect { |dm| dm.efar_location.id==efar_locations(:trill_road).id }, "Couldn't trill road"
  end
end
