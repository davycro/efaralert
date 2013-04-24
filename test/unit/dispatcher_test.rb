require 'test_helper'

class DispatcherTest < ActiveSupport::TestCase

  test "ignore case when setting password" do
    d = Dispatcher.new
    d.full_name = "David Crockett"
    d.password  = "David"
    d.password_confirmation = "daviD"
    assert d.save, "failed to save"
    assert d.authenticate("daVid"), "could not authenticate"
    assert d.authenticate("david"), "could not authenticate"
    assert !(d.authenticate("wrong password")), "allowed a bad password"
  end

end