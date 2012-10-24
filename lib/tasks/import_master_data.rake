desc 'seed data require for efar import'
task :seed_efar_requirements => :environment do
  puts "creating admin named david"
  Admin.where(:full_name => 'David Crockett', :email => 'me@davecro.com').first_or_create do |a|
    a.password = 'colorado'
    a.password_confirmation = 'colorado'
  end

  puts "creating Lavender Hill community center"
  CommunityCenter.where(:name => "Mother's Unite", :suburb => "Lavender Hill").first_or_create do |c|
    c.street = "38 Gladiola Road, Hillview"
    c.postal_code = "7945"
    c.city = "Cape Town"
    c.province = "Western Cape"
    c.country = "South Africa"
  end

end


desc 'import manenberg efars'
task :import_manenberg_efars => :environment do
  DEBUG = false

  puts "creating manenberg community center"
  community_center = CommunityCenter.where(:name => "The People's Centre", :suburb => "Manenberg").first_or_create do |c|
    c.street = "2a Scheldt Road"
    c.postal_code = "7764"
    c.city = "Cape Town"
    c.province = "Western Cape"
    c.country = "South Africa"
  end

  Efar.delete_all
  
  require 'roo'
  require 'iconv'
  
  ss = Excel.new(Rails.root.join('lib/EFAR_Master_Data.xls').to_s)
  ss.default_sheet = ss.sheets.first
  
  start_line = 3
  if DEBUG
    stop_line = 5
  else
    stop_line = 1245
  end
  num_saved = 0
  num_rejected = 0

  line = start_line-1
  while true do
    line += 1 # move to the next line
    
    if line > stop_line
      break
    end
    
    efar = Efar.new
    
    efar.surname = ss.cell(line, 'A')
    efar.first_names = ss.cell(line, 'B')
    efar.street = ss.cell(line, 'C')

    # have to parse community and postal code
    # e.g. turn "manenberg 7764 into two strings"
    comm = ss.cell(line, 'D')
    if (comm.present? and comm.is_a?(String))
      efar.postal_code = comm[/\d{4}$/]
      efar.suburb = comm.scan(/\D+/).collect { |w| w.strip }.join(" ")
    end
    efar.province = "Western Cape"
    efar.city = "Cape Town"
    efar.country = "South Africa"

    # process phone number
    pn = ss.cell(line, 'E')
    if pn.present?
      efar.contact_number = pn.to_s.scan(/\d+/).join
    end

    # community center
    efar.community_center = community_center

    # check if efar passed the course
    score = ( ss.cell(line, 'Y') || 0.0 ).to_f
    if score > 100.0
      score = score / 100.0
    end
    efar.training_score = score
    efar.training_location = ss.cell(line, 'U')
    efar.training_instructor = ss.cell(line, 'V')
    efar.training_date = ss.cell(line, 'T')

    # personal attributes
    efar.birthday = ss.cell(line, 'G')
    efar.profile = ss.cell(line, 'H')
    efar.first_language = ss.cell(line, 'K')    

    efar.save

    if efar.valid?
      num_saved += 1
    else
      num_rejected += 1
    end

    if DEBUG
      puts efar.to_yaml
    end
  end
  
  puts "done. #{num_saved} efars saved, #{num_rejected} rejected"
  
end