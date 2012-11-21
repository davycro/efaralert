# == Schema Information
#
# Table name: dispatchers
#
#  id              :integer          not null, primary key
#  full_name       :string(255)      not null
#  username        :string(255)      not null
#  password_digest :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Dispatcher < ActiveRecord::Base
  attr_accessible :full_name, :password, :password_confirmation, :username

  has_secure_password

  validates :username, :full_name, :password_digest, 
    :presence => true

  validates :password, :on => :create, :presence => true

  validates :username, :uniqueness => true

  has_many :emergencies
end
