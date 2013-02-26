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