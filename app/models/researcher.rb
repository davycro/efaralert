class Researcher < ActiveRecord::Base
  attr_accessible :email, :full_name, :password, :password_confirmation, :affiliation

  has_secure_password

  validates :email, :full_name, :password_digest, 
    :presence => true

  validates :password, :on => :create, :presence => true

  validates :email, :uniqueness => true

end
