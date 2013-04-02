def efars_full_names
	[
		"Hilda Moses",
		"Mary-ann Okkers",
		"Anthonette Fortune",
		"Fredae Freeman",
		"Inaseetah Abass",
		"Kashiya Petersen",
		"Gaironesa Smith",
		"Bramjyn Timmie",
		"Faweeza Petersen",
		"Juliana September",
		"Marjorie Van Der Vent",
		"Ramona Isaacs",
		"Moganiat Shahied Cupido",
		"Patricia Norman",
		"Rabia Lottering",
		"Rosia Brits",
		"Cheryl Ann Johnson",
		"Magdalena Lombard",
		"Elaine Goodwin",
		"Lameez Morris"
	]
end

def send_bib_message(full_name)

	efar = Efar.find_by_full_name(full_name)
	if efar.blank?
		puts "Could not find EFAR: #{full_name}"
		return
	end

	puts "messaging #{full_name}"
	message = "Y'ello #{full_name}. You are now an active EFAR! Come pick your official hat and bib at the Manenberg People's Centre today! David Crockett 0714399721"
	efar.send_text_message message

end

task :send_bib_message => :environment do

	efars_full_names.each do |full_name|
		send_bib_message full_name
	end
  # send_bib_message "David Crockett"


end