def deliver_first_recruitment_text_message(candidate_efar)
  p1 = "Attn #{candidate_efar.full_name}!\n"
  p1 << "EFAR Meeting at Mothers Unite, EFAR training center.\n"
  p1 << "Saturday 26 January. 09h00 to 11h00.\n (1/2)"
  p2 = "All trained and certified EFARs please come find out how to receive FREE Text Messages.\n"
  p2 << "Uncollected certificates will be handed over on the day. (2/2)"

  number = "27#{candidate_efar.contact_number}"

  response = SMS_API.send_message(number, p1) 
  if response[:status] != 'success'
    puts response.to_yaml
  end
  candidate_efar.first_invite_status_part_one = response[:status]
  candidate_efar.save

  response = SMS_API.send_message(number, p2) 
  if response[:status] != 'success'
    puts response.to_yaml
  end
  candidate_efar.first_invite_status_part_two = response[:status]
  candidate_efar.save

  $stdout.printf("%-3s %-50s %-20s %-10s %-10s\n", '', candidate_efar.full_name, 
    number, candidate_efar.first_invite_status_part_one, 
    candidate_efar.first_invite_status_part_two)
end

def deliver_second_recruitment_text_message(candidate_efar)
  p1 = "Reminder: EFAR Meeting at Mothers Unite, EFAR training center.\n"
  p1 << "Saturday 26 January. 09h00 to 11h00.\n"
  p1 << "Corner of St. Stephen Ave & Military Rd.\n (1/2)"
  p2 = "All trained and certified EFARs please come find out how to receive FREE Text Messages.\n"
  p2 << "Uncollected certificates will be handed over on the day. (2/2)"

  number = "27#{candidate_efar.contact_number}"

  response = SMS_API.send_message(number, p1) 
  if response[:status] != 'success'
    puts response.to_yaml
  end
  candidate_efar.second_invite_part_one = response[:status]
  candidate_efar.save

  response = SMS_API.send_message(number, p2) 
  if response[:status] != 'success'
    puts response.to_yaml
  end
  candidate_efar.second_invite_part_two = response[:status]
  candidate_efar.save

  $stdout.printf("%-3s %-50s %-20s %-10s %-10s\n", '', candidate_efar.full_name, 
    number, candidate_efar.second_invite_part_one, 
    candidate_efar.second_invite_part_two)
end

def deliver_third_recruitment_text_message(candidate_efar)
  p1 = "Reminder: EFAR Meeting at Mothers Unite, EFAR training center.\n"
  p1 << "TOMORROW! 09h00 to 11h00.\n"
  p1 << "Corner of St. Stephen Ave & Military Rd.\n (1/2)"
  p2 = "All trained and certified EFARs please come find out how to receive FREE Text Messages.\n"
  p2 << "Uncollected certificates will be handed over on the day. (2/2)"

  number = "27#{candidate_efar.contact_number}"

  response = SMS_API.send_message(number, p1) 
  if response[:status] != 'success'
    puts response.to_yaml
  end
  candidate_efar.third_invite_part_one = response[:status]
  candidate_efar.save

  response = SMS_API.send_message(number, p2) 
  if response[:status] != 'success'
    puts response.to_yaml
  end
  candidate_efar.third_invite_part_two = response[:status]
  candidate_efar.save

  $stdout.printf("%-3s %-50s %-20s %-10s %-10s\n", '', candidate_efar.full_name, 
    number, candidate_efar.third_invite_part_one, 
    candidate_efar.third_invite_part_two)
end

task :text_message_efars_to_lavender_hill_meeting => :environment do
  CommunityCenter.find_by_name("Mother's Unite").candidate_efars.each do |candidate_efar|
    deliver_third_recruitment_text_message candidate_efar
  end
end