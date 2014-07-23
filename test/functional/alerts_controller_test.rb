require 'test_helper'

class AlertsControllerTest < ActionController::TestCase
  setup do
    @alert = alerts(:one)
    admin_login
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:alerts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create alert" do
    assert_difference('Alert.count') do
      post :create, alert: {
        given_location: "Gardenia St and Gazonia St, Atlantis",
        landmarks: "By the house",
        incident_type: "Musculoskeletal complaint",
        lat: "-33.573353",
        lng: "18.49334599",
        formatted_address: "hell if i know",
        location_type: "APPROXIMATE"
      }
    end
  end
end
