# == Schema Information
#
# Table name: candidate_efars
#
#  id                           :integer          not null, primary key
#  full_name                    :string(255)      not null
#  full_address                 :string(255)
#  contact_number               :string(255)      not null
#  community_center_id          :integer          not null
#  training_score               :string(255)
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  first_invite_status_part_one :string(255)
#  first_invite_status_part_two :string(255)
#  second_invite_part_one       :string(255)
#  second_invite_part_two       :string(255)
#  third_invite_part_one        :string(255)
#  third_invite_part_two        :string(255)
#

class CandidateEfar < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :contact_number, :uniqueness => true
  validates :contact_number, :full_name, :presence => true
end
