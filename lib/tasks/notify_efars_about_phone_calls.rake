task :notify_efars_about_phone_calls => :environment do

  message = "
    Attn EFAR. Starting today, ambulance dispatchers may 
    call your phone when they need your help.
    Please keep your phone with you and the battery charged. 
    Be ready to answer calls from strange numbers.
    TY David 0714399721
  ".squish

  names = [
    'Moegmiena Salie',
    'Bramjyn Timmie',
    'Lee-Andrea Timmie',
    'Catherine Davids',
    'Brenda Yvonne Fortliin',
    'Rosia Brits',
    'Moria Crowder',
    'Glenda Odendaal',
    'Nfombosinoiso Sigwebedlana',
    'Shirley Nangeni',
    'Shiella Mzukwe',
    'Gubani Xekethwang',
    'Catherine Van Heerden',
    'Craig Valentine',
    'Janine Festus',
    'Samanski Tibo',
    'Nomfundo Mtsamayi',
    'Buyiswa Malwenga-Sonyolea',
    'Gugu Matie',
    'Nteboheleny Manko',
    'Abdul Basiet Jeppie',
    'Michelle Freeman',
    'Deon Jones',
    'Nonzukiso Batyi',
    'Inaseetah Abass',
    'Juliana September',
    'Rabia Lottering',
    'Mary-ann Okkers',
    'Nothlekela Mkoko',
    'Suraya Visagie',
    'Nontsikelelo Kenke'
  ]

  names.each do |full_name|
    puts "Messaging: #{full_name}"
    Efar.find_by_full_name(full_name).send_text_message(message)
  end

  # Efar.find_by_full_name("David Crockett").send_text_message message

end

