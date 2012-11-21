# == Schema Information
#
# Table name: head_efars
#
#  id                  :integer          not null, primary key
#  full_name           :string(255)      not null
#  community_center_id :integer          not null
#  email               :string(255)      not null
#  password_digest     :string(255)      not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class HeadEfar < ActiveRecord::Base
  attr_accessible :community_center_id, :email, :full_name, :password, :password_confirmation

  has_secure_password

  validates :community_center_id, :email, :full_name, :password_digest,
    :presence => true

  validates :password, :on => :create, :presence => true

  validates :email, :uniqueness => true

  belongs_to :community_center
end
