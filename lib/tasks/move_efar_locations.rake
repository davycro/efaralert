task :move_efar_locations => :environment do

  EfarLocation.all.each do |l|

    efar = l.efar
    efar.lat = l.lat
    efar.lng = l.lng
    efar.formatted_address = l.formatted_address
    efar.location_type = l.location_type
    efar.save

    puts "saved #{efar.full_name}, #{efar.lat}"

  end

end