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

desc 'import manenberg phone register'
task :import_manenberg_efar_candidates => :environment do

  #
  # file information
  spread_sheet_root_file_path = 'lib/registers/Manenberg_Phone_Register.xls'

  #
  # column variables
  surname_column        = 'A'
  first_name_column     = 'B'
  contact_number_column = 'C'

  #
  # row configuration
  start_row = 2
  final_row = 891

  #
  # miscelleanous settings
  debug_mode = true

  #
  # initialize the community centre
  community_center = CommunityCenter.where(:name => "The People's Centre", :suburb => "Manenberg").first_or_create do |c|
    c.street = "2a Scheldt Road"
    c.postal_code = "7764"
    c.city = "Cape Town"
    c.province = "Western Cape"
    c.country = "South Africa"
  end

  #
  # open the spreadsheet
  require 'roo'
  require 'iconv'

  ss = Excel.new(Rails.root.join(spread_sheet_root_file_path).to_s)
  ss.default_sheet = ss.sheets.first

  #
  # drop old entries
  CandidateEfar.where(:community_center_id => community_center.id).delete_all

  #
  # loop through every row of the register
  selected_row = start_row
  while selected_row <= final_row do

    efar = CandidateEfar.new

    surname    = ss.cell(selected_row, surname_column)
    first_name = ss.cell(selected_row, first_name_column)
    efar.full_name = "#{first_name} #{surname}".squish.titleize

    contact_number = ss.cell(selected_row, contact_number_column)
    if contact_number.present?
      efar.contact_number = contact_number.to_s.scan(/\d+/).join.to(8)
    end

    efar.community_center_id = community_center.id

    if efar.save
      $stdout.printf("%-3s %-50s %-20s\n", 
        '', efar.full_name, efar.contact_number)
    end
    
    selected_row += 1 # must be at the end of the loop
  end

end

desc 'import lavender hill efars for bulk mailing'
task :import_lavender_hill_efar_candidates => :environment do

  #
  # file information
  spread_sheet_root_file_path = 'lib/Lavender_Hill_EFAR_Master_Register.xls'

  #
  # column configuration parameters
  surname_column        = 'A'
  first_name_column     = 'B'
  address_column        = 'C'
  community_column      = 'D'
  contact_number_column = 'E'
  course_pass_column    = 'X'

  #
  # row configuration parameters
  start_row = 3
  final_row = 161

  #
  # miscelleanous settings
  debug_mode = true

  #
  # initialize the lavender hill community centre
  community_center = CommunityCenter.where(:name => "Mother's Unite", 
    :suburb => "Lavender Hill").first_or_create do |c|
    c.street = "38 Gladiola Road, Hillview"
    c.postal_code = "7945"
    c.city = "Cape Town"
    c.province = "Western Cape"
    c.country = "South Africa"
  end

  #
  # open the spreadsheet
  require 'roo'
  require 'iconv'

  ss = Excel.new(Rails.root.join(spread_sheet_root_file_path).to_s)
  ss.default_sheet = ss.sheets.first

  #
  # drop old lavender hill entries
  CandidateEfar.where(:community_center_id => community_center.id).delete_all

  #
  # loop through every row of the register
  selected_row = start_row
  while selected_row <= final_row do

    efar = CandidateEfar.new
    efar_certified = false

    surname    = ss.cell(selected_row, surname_column)
    first_name = ss.cell(selected_row, first_name_column)
    efar.full_name = "#{first_name} #{surname}".titleize

    address   = ss.cell(selected_row, address_column)
    community = ss.cell(selected_row, community_column)
    efar.full_address = [address, community, "Cape Town", "South Africa"].
      compact.join(', ')

    contact_number = ss.cell(selected_row, contact_number_column)
    if contact_number.present?
      efar.contact_number = contact_number.to_s.scan(/\d+/).join.to(8)
    end

    course_pass = ss.cell(selected_row, course_pass_column)
    if course_pass.present?
      course_pass = course_pass.to_s.downcase
      if course_pass[0] == 'p'
        efar_certified = true
      end
      efar.training_score = course_pass
    end

    efar.community_center_id = community_center.id

    if efar_certified
      if efar.save
        $stdout.printf("%-3s %-50s %-20s %-5s\n", 
          '', efar.full_name, efar.contact_number, efar.training_score)
      end
    end
    
    selected_row += 1 # must be at the end of the loop
  end

end