desc 'seed admin login data'
task :seed_admin => :environment do
  puts "creating admin named david"
  Admin.where(:full_name => 'David Crockett', :email => 'me@davecro.com').
    first_or_create do |a|
    
    a.password = 'colorado'
    a.password_confirmation = 'colorado'
  end
end

desc 'seed manenberg peoples centre'
task :seed_manenberg_community_centre => :environment do
  puts "creating manenberg community center"
  community_center = CommunityCenter.where(:name => "The People's Centre", :suburb => "Manenberg").first_or_create do |c|
    c.street = "2a Scheldt Road"
    c.postal_code = "7764"
    c.city = "Cape Town"
    c.province = "Western Cape"
    c.country = "South Africa"
  end
  community_center.geocode
  community_center.save!
end

desc 'import lavender hill efars'
task :import_lavender_hill_efars => :environment do
  puts "creating Lavender Hill Community Center"
  community_center = CommunityCenter.where(:name => "Mother's Unite", :suburb => "Lavender Hill").first_or_create do |c|
    c.street = "38 Gladiola Road, Hillview"
    c.postal_code = "7945"
    c.city = "Cape Town"
    c.province = "Western Cape"
    c.country = "South Africa"
  end

  require 'roo'
  require 'iconv'

  ss = Excel.new(Rails.root.join('lib/LH_Register.xls').to_s)
  ss.default_sheet = ss.sheets.first

  start_line = 3
  stop_line = 70

  line = start_line-1
  while true do
    line+=1
    if line>stop_line
      break
    end

    #
    # Data Extraction
    surname = ss.cell(line, 'A')
    first_name = ss.cell(line, 'B')
    street = ss.cell(line, 'C')
    # have to parse community and postal code
    # e.g. turn "manenberg 7764 into two strings"
    comm = ss.cell(line, 'D')
    if (comm.present? and comm.is_a?(String))
      postal_code = comm[/\d{4}$/]
      suburb = comm.scan(/\D+/).collect { |w| w.strip }.join(" ")
    end
    # process phone number
    pn = ss.cell(line, 'E')
    if pn.present?
      contact_number = pn.to_s.scan(/\d+/).join
    end
    # check if efar passed the course
    score = ( ss.cell(line, 'Y') || 0.0 ).to_f
    if score > 1.0
      score = score / 10.0
    end

    #
    # Save data to database
    efar = Efar.where(:surname => surname, :first_names => first_names, :street => street).first_or_create do |e|
      e.postal_code = postal_code
      e.suburb = suburb
      e.city = "Cape Town"
      e.province = "Western Cape"
      e.country = "South Africa"
      e.contact_number = contact_number
      e.training_score = score
      e.training_location = ss.cell(line, 'U')
      e.training_date = ss.cell(line, 'T')
      e.training_instructor  = ss.cell(line, 'V')
      e.profile = ss.cell(line, 'H')
      e.birthday = ss.cell(line, 'G')
      e.community_center = community_center
    end

    puts efar.to_yaml
  end
end


desc 'import manenberg efars'
task :import_manenberg_efars_candidates => :environment do
  DEBUG = false

  puts "creating manenberg community center"
  community_center = CommunityCenter.where(:name => "The People's Centre", :suburb => "Manenberg").first_or_create do |c|
    c.street = "2a Scheldt Road"
    c.postal_code = "7764"
    c.city = "Cape Town"
    c.province = "Western Cape"
    c.country = "South Africa"
  end

  CandidateEfar.delete_all
  
  require 'roo'
  require 'iconv'
  
  ss = Excel.new(Rails.root.join('lib/Manenberg_EFAR_Master_Register.xls').to_s)
  ss.default_sheet = ss.sheets.first
  
  start_line = 3
  if DEBUG
    stop_line = 30
  else
    stop_line = 1692
  end
  num_saved = 0
  num_rejected = 0

  line = start_line-1
  while true do
    line += 1 # move to the next line
    
    if line > stop_line
      break
    end
    
    efar = CandidateEfar.new
    
    surname = ss.cell(line, 'A')
    first_name = ss.cell(line, 'B')
    efar.full_name = "#{first_name} #{surname}"

    street = ss.cell(line, 'C')
    suburb = ss.cell(line, 'D')
    if street.present?
      efar.full_address = [street, suburb, "Cape Town", "South Africa"].compact.join(", ")
    end
    
    # process phone number
    pn = ss.cell(line, 'E')
    if pn.present?
      efar.contact_number = pn.to_s.scan(/\d+/).join
    end

    # community center
    efar.community_center_id = community_center.id

    # check if efar passed the course
    score = ( ss.cell(line, 'Y') || 0.0 ).to_f
    if score > 1.0
      score = score / 10.0
    end
    efar.training_score = score
     
    if score>0.8
      if efar.save
        $stdout.printf("%-3s %-50s %-20s %-5s\n", '', efar.full_name, efar.contact_number, efar.training_score)
      end
    end
  end
  
  puts "done."
  
end