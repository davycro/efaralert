# == Schema Information
#
# Table name: admins
#
#  id              :integer          not null, primary key
#  full_name       :string(255)      not null
#  email           :string(255)      not null
#  password_digest :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Admin < ActiveRecord::Base
  attr_accessible :email, :full_name, :password, :password_confirmation

  has_secure_password

  validates :email, :full_name, :password_digest, 
    :presence => true

  validates :password, :on => :create, :presence => true
  validates :email, :uniqueness => true

end
