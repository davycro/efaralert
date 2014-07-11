# == Schema Information
#
# Table name: study_invites
#
#  id         :integer          not null, primary key
#  efar_id    :integer          not null
#  accepted   :boolean          default(FALSE)
#  rejected   :boolean          default(FALSE)
#  opened     :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class StudyInvite < ActiveRecord::Base
  attr_accessible :accepted, :efar_id

  scope :accepted, where(accepted: true)
  scope :pending, where(accepted: false)

  validates :efar_id, :uniqueness => true

  belongs_to :efar

  def pending?
    !self.accepted?
  end

  def accepted?
    self.accepted
  end

  def accepted!
    reject_url = "http://efardispatch.com/study_invites/#{self.id}/reject"
    self.accepted = true
    self.save
    self.efar.send_text_message %{
        You are now enrolled in the EFAR SMS Alert system. EFAR alerts are for your
        information only. You are not required to act upon SMS alerts, and you
        should only help if the scene is safe. Click below if you wish to stop this service:
        #{reject_url}
      }.squish
  end

  def opened!
    self.opened = true
    self.save
  end

  def rejected!
    self.accepted = false
    self.rejected = true
    self.save
  end

  def status
    if self.accepted
      "accepted"
    elsif self.rejected
      "rejected"
    elsif self.opened
      "opened"
    else
      "pending"
    end
  end

  def deliver!
    accept_url = "http://efardispatch.com/study_invites/#{self.id}"

    self.efar.send_text_message %{
      Attn EFAR! You are invited to join the EFAR SMS alert system. This system 
      will alert you when emergencies occur near your home.
      }.squish
    self.efar.send_text_message %{
      #{self.efar.full_name}, please kindly click this link to join the EFAR SMS alert system: #{accept_url}
      }.squish
  end

end
