class Dispatcher < ActiveRecord::Base
  attr_accessible :full_name, :password, :password_confirmation, :username

  has_secure_password

  validates :username, :full_name, :password_digest, 
    :presence => true

  validates :username, :uniqueness => true
end
