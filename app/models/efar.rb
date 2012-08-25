# t.string :surname, :null => false
# t.string :first_name, :null => false
# t.string :address, :null => false
# t.string :community
# t.string :postal_code, :null => false
# t.string :city, :null => false
# t.string :province
# t.string :country, :null => false
# t.string :contact_number, :null => false
# t.string :certification_level
                                 
class Efar < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :surname, :first_name, :address, :postal_code, 
    :city, :country, :contact_number, :presence => true
  validates :contact_number, :uniqueness => true
  
end
