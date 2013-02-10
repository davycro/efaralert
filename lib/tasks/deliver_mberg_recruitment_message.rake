def deliver_first_message(candidate_efar)
  m = ""
  m << "Attn #{candidate_efar.full_name}!\n"
  m << "EFAR Meeting at The People's Centre\n"
  m << "Thursday 21 February. 10h00 to 12h00\n"
  m << "All trained and certified EFARs please come find out how to receive FREE text messages!\n"
  m << "Uncollected certificates will be handed over on the day.\n"
  m << "From: Michelle Klaasen, Manenberg People's Centre, 0846504453"

  number = "27#{candidate_efar.contact_number}"

  response = SMS_API.send_message(number, m)
  if response[:status] != 'success'
    puts response.to_yaml
  end
  candidate_efar.first_invite_status_part_one = response[:status]
  candidate_efar.save
end

task :send_first_invite_to_manenberg => :environment do

  # raise "careful now!"

  community_center = CommunityCenter.find_by_name("The People's Centre")
  # efar = CandidateEfar.where(:full_name=>'David Crockett', :community_center_id=>community_center.id).first
  CandidateEfar.where(:community_center_id => community_center.id, :first_invite_status_part_one => nil).all.each do |efar|
    deliver_first_message efar
  end

end