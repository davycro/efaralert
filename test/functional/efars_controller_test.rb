require 'test_helper'

class EfarsControllerTest < ActionController::TestCase
  setup do
    manager_login
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:efars)
  end

  test "should get bibbed" do
    get :bibbed
    assert_response :success
    assert_not_nil assigns(:efars)
  end

  test "should get expired" do
    get :expired
    assert_response :success
    assert_not_nil assigns(:efars)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create alert" do
    assert_difference('Efar.count') do
      post :create, efar: {
        full_name: "david",
        contact_number: "0608042569",
        given_address: "50 trill road"
      }
    end
  end
end
