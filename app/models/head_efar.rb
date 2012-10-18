class HeadEfar < ActiveRecord::Base
  attr_accessible :community_center_id, :email, :full_name, :password, :password_confirmation

  has_secure_password

  validates :community_center_id, :email, :full_name, :password_digest,
    :presence => true

  validates :password, :on => :create, :presence => true

  validates :email, :uniqueness => true

  belongs_to :community_center
end
