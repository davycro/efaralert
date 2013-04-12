# == Schema Information
#
# Table name: suburbs
#
#  id                :integer          not null, primary key
#  name              :string(255)      not null
#  lat               :float
#  lng               :float
#  formatted_address :string(255)
#  location_type     :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Suburb < ActiveRecord::Base
  attr_accessible :name, :lat, :lng, :formatted_address, :location_type

  validates :name, :presence => true
end
