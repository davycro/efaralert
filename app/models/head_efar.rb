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
#  contact_number      :string(255)      not null
#

class HeadEfar < ActiveRecord::Base
  attr_accessible :community_center_id, :email, :full_name, :contact_number, 
    :password, :password_confirmation

  has_secure_password

  validates :community_center_id, :email, :full_name, :password_digest, 
    :contact_number, :presence => true

  validates :password, :on => :create, :presence => true

  validates :email, :uniqueness => true

  belongs_to :community_center

  def send_text_message(message)
    return SMS_API.send_message(self.contact_number, message)
  end
end
