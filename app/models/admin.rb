class Admin < ActiveRecord::Base
  attr_accessible :email, :full_name, :password, :password_confirmation

  has_secure_password

  validates :email, :full_name, :password_digest, 
    :presence => true

  validates :email, :uniqueness => true

end
