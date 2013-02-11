# == Schema Information
#
# Table name: slum_dispatch_messages
#
#  id                       :integer          not null, primary key
#  slum_emergency_id        :integer          not null
#  efar_id                  :integer          not null
#  clickatell_error_message :string(255)
#  state                    :string(255)      default("queued")
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

require 'test_helper'

class SlumDispatchMessageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
