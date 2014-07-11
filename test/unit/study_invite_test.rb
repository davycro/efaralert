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

require 'test_helper'

class StudyInviteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
