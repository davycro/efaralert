# == Schema Information
#
# Table name: slum_emergencies
#
#  id            :integer          not null, primary key
#  slum_id       :integer          not null
#  category      :string(255)
#  shack_number  :string(255)
#  dispatcher_id :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class SlumEmergencyTest < ActiveSupport::TestCase
  test "creates dispatch messages after creation" do
    #
    # configuration parameters
    dispatcher   = dispatchers(:davycro)
    category     = "Uncontrolled bleed"
    efar_names   = %w(david buck jack)
    slum         = slums(:overcome)
    shack_number = "21" 

    #
    # associate efars with informal settlements
    efar_names.each do |efar_name|
      efar = efars(efar_name.to_sym)
      efar.slum = slum
      efar.save
    end

    #
    # create an emergency
    emergency = SlumEmergency.create(
        :dispatcher_id => dispatcher.id,
        :category      => category,
        :slum_id       => slum.id,
        :shack_number  => shack_number
      )

    #
    # assertions
    assert_equal efar_names.size, emergency.slum_dispatch_messages.size 

  end
end
