# == Schema Information
#
# Table name: managers
#
#  id                  :integer          not null, primary key
#  full_name           :string(255)      not null
#  username            :string(255)      not null
#  password_digest     :string(255)      not null
#  community_center_id :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Manager < ActiveRecord::Base
  attr_accessible :full_name, :username, :community_center_id, 
    :password, :password_confirmation

  has_secure_password
  belongs_to :community_center

  validates :full_name, :username, :community_center_id, presence: true
  validates :username, uniqueness: true

  def community
    @community ||= self.community_center
  end
end
