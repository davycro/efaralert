# == Schema Information
#
# Table name: slums
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Slum < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name

  validates :name, :presence => true

  before_destroy :nullify_associated_efars

  has_many :efars

  def nullify_associated_efars
    Efar.where(:slum_id => self.id).update_all(:slum_id => nil)
  end
end
