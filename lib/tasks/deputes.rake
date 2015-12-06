namespace :deputes do

  desc 'open AN JSON and seed DB'
  task :seed => :environment do
    def open_json
      filepath = '../../app/data/AMO10_deputes_actifs_mandats_actifs_organes_XIV.json'
      p 'Opening json...'
      JSON.parse(File.open(filepath).read)
    end

    d = open_json['export']['acteurs']['acteur'].first

    civ = d['etatCivil']['ident']['civ']
    firstname = d['etatCivil']['ident']['prenom']
    lastname = d['etatCivil']['ident']['nom']
    birthday = d['etatCivil']['infoNaissance']['dateNais']
    birthdep = d['etatCivil']['infoNaissance']['depNais']
    job = d['profession']['libelleCourant']
    jobcat = d['profession']['socProcINSEE']['catSocPro']
    jobtype = d['profession']['socProcINSEE']['famSocPro']

    # TODO

  end

end
