# == Schema Information
#
# Table name: dispatches
#
#  id                    :integer          not null, primary key
#  dispatcher_id         :integer          not null
#  emergency_category    :string(255)
#  township_id           :integer
#  township_house_number :string(255)
#  landmarks             :string(255)
#  lat                   :float
#  lng                   :float
#  formatted_address     :string(255)
#  location_type         :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require 'test_helper'

class DispatchTest < ActiveSupport::TestCase

  def initialize_dispatch_to_trill_road
    trill_road = efars(:trill_road)
    dispatch = Dispatch.new(lat: trill_road.lat,
      lng: trill_road.lng,
      dispatcher_id: 1,
      formatted_address: "50 trill road, cape town",
      emergency_category: "broken bone"
    )
    return dispatch
  end

  test "should know its location type" do
    assert dispatches(:overcome).nil_geolocation?
    assert !dispatches(:overcome).has_geolocation?
    assert dispatches(:trill_road).has_geolocation?
  end

  test "should find nearby efars" do
    broken_bone = initialize_dispatch_to_trill_road
    nearby_efars = broken_bone.nearby_efars
    assert nearby_efars.include?(efars(:trill_road))
    assert nearby_efars.include?(efars(:herschel_road))
  end

  test "should create dispatch messages for a street address" do
    dispatch = initialize_dispatch_to_trill_road
    assert dispatch.save, "Dispatch did not save: #{dispatch.to_yaml}"
    dispatch = Dispatch.find(dispatch.id)
    assert dispatch.messages.present?, "No dispatch messages created"
    assert dispatch.messages.detect { |dm| dm.efar.id==efars(:trill_road).id }, "Couldn't trill road"
  end

  test "creates dispatch messages for a township" do
    #
    # configuration parameters
    dispatcher            = dispatchers(:davycro)
    category              = "Uncontrolled bleed"
    efar_names            = %w(david buck jack)
    township              = townships(:overcome)
    township_house_number = "21" 

    #
    # associate efars with informal settlements
    efar_names.each do |efar_name|
      efar = efars(efar_name.to_sym)
      efar.update_attribute :township_id, township.id
    end

    #
    # create a dispatch
    dispatch = Dispatch.create(
        :dispatcher_id         => dispatcher.id,
        :emergency_category    => category,
        :township_id           => township.id,
        :township_house_number => township_house_number
      )

    #
    # assertions
    assert_equal efar_names.size, dispatch.messages.size 

  end

end
