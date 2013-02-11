class Simulation

  def self.slum_emergency

    #
    # slum variables
    slum_name = "Hillview One"
    slum = Slum.where(:name => slum_name).first_or_create

    #
    # community centre
    community_center = CommunityCenter.where(:name => "Mothers Unite").first_or_create

    #
    # efar variables


    #
    # emergency variables
    dispatcher   = Dispatcher.find_by_username "davycro"
    shack_number = "21"
    category     = "Uncontrolled bleed"

    emergency = SlumEmergency.create(
      :dispatcher_id => dispatcher.id,
      :category      => category,
      :slum_id       => slum.id,
      :shack_number  => shack_number
    )

  end

end