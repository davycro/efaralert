require 'test_helper'

class EfarsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
