class Simulation

  def self.hillview_three

    #
    # slum variables
    slum_name = "Hillview Three"
    slum = Slum.where(:name => slum_name).first_or_create

    #
    # community centre
    community_center = CommunityCenter.find_or_initialize_by_name "Candyland Center"
    community_center.street = "candy way"
    community_center.postal_code = "7925"
    community_center.city = "cape town"
    community_center.country = "south africa"
    community_center.save!

    #
    # efar variables
    efar_one = Efar.find_or_initialize_by_contact_number "27714399721"
    efar_one.slum             = slum
    efar_one.full_name        = "David Crockett"
    efar_one.community_center = community_center
    efar_one.save!

    #
    # head efar variables
    first_head_efar = HeadEfar.find_or_initialize_by_contact_number "27714399721"
    first_head_efar.full_name = "David Crockett"
    first_head_efar.community_center = community_center
    first_head_efar.save!

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

    emergency.dispatch_head_efars!
    emergency.dispatch_efars!
  end

end