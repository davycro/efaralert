def deliver_first_message(candidate_efar)
  m1 = ""
  m2 = ""
  m1 << "Attn #{candidate_efar.full_name}!\n"
  m1 << "EFAR Meeting at The People's Centre\n"
  m1 << "Thursday 21 February. 10h00 to 12h00 (1/2)\n"
  m2 << "All trained and certified EFARs please come find out how to receive FREE text messages!\n"
  m2 << "Uncollected certificates will be handed over on the day.\n"
  m2 << "From: Michelle Klaasen, Manenberg People's Centre, 0846504453 (2/2)"

  number = "27#{candidate_efar.contact_number}"

  response = SMS_API.send_message(number, m1)
  if response[:status] != 'success'
    puts response.to_yaml
  end
  candidate_efar.first_invite_status_part_one = response[:status]
  candidate_efar.save

  response = SMS_API.send_message(number, m2)
  if response[:status] != 'success'
    puts response.to_yaml
  end
  candidate_efar.first_invite_status_part_two = response[:status]
  candidate_efar.save

end

def deliver_second_message(candidate_efar)
  m1 = ""
  m2 = ""
  m1 << "Attn #{candidate_efar.full_name}!\n"
  m1 << "EFAR Meeting at The People's Centre\n"
  m1 << "Thames Ave & Scheldt St\n"
  m1 << "Thursday 21 February. 10h00 to 12h00 (1/2)\n"
  m2 << "All trained EFARs please come find out how to receive FREE text messages! \n"
  m2 << "From: Michelle Klaasen, Manenberg People's Centre, 0846504453"

  number = "27#{candidate_efar.contact_number}"

  response = SMS_API.send_message(number, m1)
  if response[:status] != 'success'
    puts response.to_yaml
  end
  candidate_efar.second_invite_part_one = response[:status]
  candidate_efar.save

  response = SMS_API.send_message(number, m2)
  if response[:status] != 'success'
    puts response.to_yaml
  end
  candidate_efar.second_invite_part_two = response[:status]
  candidate_efar.save

end

def deliver_third_message(candidate_efar)
  m1 = ""
  m2 = ""
  m1 << "Attn #{candidate_efar.full_name}!\n"
  m1 << "EFAR Meeting at The People's Centre\n"
  m1 << "Thames Ave & Scheldt St\n"
  m1 << "TOMORROW 21 Feb. 10h00 to 12h00\n"
  m2 << "All trained EFARs please come find out how to receive FREE text messages! \n"
  m2 << "From: Michelle Klaasen, Manenberg People's Centre, 0846504453"

  number = "27#{candidate_efar.contact_number}"

  response = SMS_API.send_message(number, m1)
  if response[:status] != 'success'
    puts response.to_yaml
  end
  candidate_efar.third_invite_part_one = response[:status]
  candidate_efar.save

  response = SMS_API.send_message(number, m2)
  if response[:status] != 'success'
    puts response.to_yaml
  end
  candidate_efar.third_invite_part_two = response[:status]
  candidate_efar.save

end

task :send_third_invite_to_manenberg => :environment do

  community_center = CommunityCenter.find_by_name("The People's Centre")
  CandidateEfar.where(:community_center_id=>community_center.id, :third_invite_part_one => nil).all.each do |efar|
    deliver_third_message efar
  end

end

