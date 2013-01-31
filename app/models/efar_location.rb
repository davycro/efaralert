# == Schema Information
#
# Table name: efar_locations
#
#  id                :integer          not null, primary key
#  efar_id           :integer          not null
#  occupied_at       :string(255)
#  given_address     :string(255)      not null
#  formatted_address :string(255)      not null
#  lat               :float            not null
#  lng               :float            not null
#  location_type     :string(255)
#

class EfarLocation < ActiveRecord::Base
end
