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

require 'test_helper'

class HeadEfarTest < ActiveSupport::TestCase

  test "can send text message" do
    head_efar = head_efars(:david)
    response = head_efar.send_text_message "this is just a test"
    assert response[:status]=='success'
  end

end
