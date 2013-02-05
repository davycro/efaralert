# == Schema Information
#
# Table name: efars
#
#  id                  :integer          not null, primary key
#  full_name           :string(255)      not null
#  community_center_id :integer          not null
#

require 'test_helper'

class EfarTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "has many locations" do
    david = efars(:david)
    assert david.locations.present?
  end
  test "has many contact numbers" do
    david = efars(:david)
    assert david.contact_numbers.present?
  end
end