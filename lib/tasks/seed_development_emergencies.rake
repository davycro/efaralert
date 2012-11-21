desc "adds three emergencies for development usauge"
task :seed_development_emergencies => :environment do
  
  # REQUIRED DATA TO RUN THIS SCRIPT
  # Dispatcher
  #

  unless Rails.env=="development"
    raise "task restricted to development environment"
  end

  Emergency.destroy_all

  Emergency.create(
    :dispatcher_id     => Dispatcher.all.shuffle.first.id,
    :input_address     => "200 Depsition Crescent, Cape Town, South Africa",
    :formatted_address => "Despsiton Crescent, Cape Town 7945, South Africa",
    :lat               => -34.0743,
    :lng               => 18.4871,
    :location_type     => "GEOMETRIC_CENTER"
  )

  Emergency.create(
    dispatcher_id: Dispatcher.all.shuffle.first.id,
    input_address: "50 trill road, Cape Town, South Africa",
    formatted_address: "50 Trill Rd, Cape Town 7925, South Africa",
    lat: -33.9391,
    lng: 18.4702,
    location_type: "ROOFTOP" )

  puts "Done. Created two emergencies"

end