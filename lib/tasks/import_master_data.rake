
desc 'seed efar mapping data'
task :import_master_data => :environment do
  Efar.delete_all
  
  require 'roo'
  require 'iconv'
  
  ss = Excel.new(Rails.root.join('lib/EFAR_Master_Data.xls').to_s)
  ss.default_sheet = ss.sheets.first
  
  # start infinite loop
  line = 2 # first line in the spreadsheet
  num_saved = 0
  num_rejected = 0
  while true do
    line += 1 # move to the next line
    
    if line > 1060
      break
    end
    
    efar = Efar.new
    
    efar.surname = ss.cell(line, 'A')
    efar.first_name = ss.cell(line, 'B')
    # check if efar passed the course
    score = ss.cell(line, 'Y')
    if score.blank?
      num_rejected += 1
      next
    end
    if score.present?
      score = score.to_f * 100.0
      if score > 100.0
        score = score / 100.0
      end
      if score > 80.0
        efar.certification_level = "basic efar"
      else
        num_rejected += 1
        next
      end
    end
    
    efar.address = ss.cell(line, 'C')
    # have to parse community and postal code
    # e.g. turn "manenberg 7764 into two strings"
    comm = ss.cell(line, 'D')
    next if comm.blank?
    efar.postal_code = comm[/\d{4}$/]
    efar.community = comm.scan(/\D+/).collect { |w| w.strip }.join(" ")
    efar.province = "Western Cape"
    efar.city = "Cape Town"
    efar.country = "South Africa"
    # process phone number
    pn = ss.cell(line, 'E')
    next if pn.blank?
    efar.contact_number = pn.scan(/\d+/).join
    
    efar.save
    if efar.valid?
      num_saved += 1
    else
      num_rejected += 1
    end
  end
  
  puts "done. #{num_saved} efars saved, #{num_rejected} rejected"
  
end