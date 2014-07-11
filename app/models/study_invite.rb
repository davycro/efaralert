# == Schema Information
#
# Table name: study_invites
#
#  id         :integer          not null, primary key
#  efar_id    :integer          not null
#  accepted   :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class StudyInvite < ActiveRecord::Base
  attr_accessible :accepted, :efar_id

  scope :accepted, where(accepted: true)
  scope :pending, where(accepted: false)

  def pending?
    !self.accepted?
  end

  def accepted?
    self.accepted
  end

end
