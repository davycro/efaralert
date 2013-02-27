desc "show efars who are not candidates"

task :verify_phone_number => :environment do

  Efar.all.each do |efar|

    contact_number = efar.contact_number[2..-1] 

    c = CandidateEfar.find_by_contact_number(contact_number)
    if c.blank?
      $stdout.printf("%-3s %-50s %-20s %-20s\n", 
        '', efar.full_name, efar.readable_contact_number, efar.community_center.name)
    end

  end

end

task :efars_near, [:input_address]=> [:environment] do |t, args|
  search_address = args[:input_address] + ", cape town, south africa"

  efars = Efar.near(search_address, 0.3, :order => "distance")
  puts "Found #{efars.size} efar(s) near #{search_address}: "
  efars.each do |efar|
    $stdout.printf "%-3s %-50s %-20s %-50s\n", '', efar.full_name, efar.readable_contact_number, efar.formatted_address
  end

end

task :scramble_efar_contact_numbers => :environment do

  raise "dev only!" unless Rails.env == 'development'

  Efar.all.each do |efar|
    efar.contact_number = efar.contact_number + "9"
    efar.save
  end

end