namespace :deputes do

  desc 'open AN JSON and seed DB'
  task :seed => :environment do
    def open_json
      filepath = '../../app/data/AMO10_deputes_actifs_mandats_actifs_organes_XIV.json'
      p 'Opening json...'
      JSON.parse(File.open(filepath).read)
    end

    open_json['export']['acteurs']['acteurs'].each do |d|
      civility = d['etatCivil']['ident']['civ']
      firstname = d['etatCivil']['ident']['prenom']
      name = d['etatCivil']['ident']['nom']
      birthdate = d['etatCivil']['infoNaissance']['dateNais']
      birthdep = d['etatCivil']['infoNaissance']['depNais']
      job = d['profession']['libelleCourant']
      jobcat = d['profession']['socProcINSEE']['catSocPro']
      jobtype = d['profession']['socProcINSEE']['famSocPro']
    end

    # TODO

  end

end
