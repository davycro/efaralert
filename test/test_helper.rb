ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def admin_login
    @admin = admins(:one)
    @admin.save
    @request.session[:admin_id] = @admin.id
  end

  def manager_login
    @manager = managers(:one)
    @manager.save
    @request.session[:manager_id] = @manager.id
  end
end

require 'mocha'