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

require 'test_helper'

class ManagerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
