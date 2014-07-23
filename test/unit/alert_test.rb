# == Schema Information
#
# Table name: alerts
#
#  id                       :integer          not null, primary key
#  given_location           :string(255)
#  landmarks                :string(255)
#  incident_type            :string(255)
#  lat                      :float
#  lng                      :float
#  formatted_address        :string(255)
#  location_type            :string(255)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  control_group            :boolean          default(FALSE)
#  distance_of_nearest_efar :float
#

require 'test_helper'

class AlertTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
