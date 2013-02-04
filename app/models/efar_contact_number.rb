# == Schema Information
#
# Table name: efar_contact_numbers
#
#  id             :integer          not null, primary key
#  efar_id        :integer          not null
#  contact_number :string(255)      not null
#

class EfarContactNumber < ActiveRecord::Base
  
  belongs_to :efar

  validates :contact_number, :efar_id, :presence => true
  
end
