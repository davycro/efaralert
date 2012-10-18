class Efar < ActiveRecord::Base
  PER_PAGE = 50

  validates :surname, :address, 
    :city, :country, :contact_number, :community_center_id, :presence => true
  validates :contact_number, :uniqueness => true

  belongs_to :community_center
  
  def self.all_for_page(page)  
    page ||= 0
    per_page = PER_PAGE

    return self.limit(per_page).offset(per_page*page).all
  end

  def full_name
    "#{self.first_names} #{self.surname}"
  end
end
