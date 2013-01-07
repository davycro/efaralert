class CandidateEfar < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :contact_number, :uniqueness => true
  validates :contact_number, :full_name, :presence => true
end
