# == Schema Information
#
# Table name: researchers
#
#  id              :integer          not null, primary key
#  full_name       :string(255)      not null
#  email           :string(255)      not null
#  affiliation     :string(255)
#  password_digest :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Researcher < ActiveRecord::Base
  attr_accessible :email, :full_name, :password, :password_confirmation, :affiliation

  has_secure_password

  validates :email, :full_name, :password_digest, 
    :presence => true

  validates :password, :on => :create, :presence => true

  validates :email, :uniqueness => true

end
