# == Schema Information
#
# Table name: alerts
#
#  id                :integer          not null, primary key
#  given_location    :string(255)
#  landmarks         :string(255)
#  incident_type     :string(255)
#  lat               :float
#  lng               :float
#  formatted_address :string(255)
#  location_type     :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Alert < ActiveRecord::Base
  # attr_accessible :title, :body
end
