# == Schema Information
#
# Table name: head_efars
#
#  id                  :integer          not null, primary key
#  full_name           :string(255)      not null
#  community_center_id :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  contact_number      :string(255)      not null
#

class HeadEfar < ActiveRecord::Base
  attr_accessible :community_center_id, :full_name, :contact_number

  validates :full_name, :contact_number, :presence => true

  belongs_to :community_center

  def send_text_message(message)
    return SMS_API.send_message(self.contact_number, message)
  end

  def community_center_name
    if community_center.present?
      return community_center.name
    else
      return "None"
    end
  end
end
