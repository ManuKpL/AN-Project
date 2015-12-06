namespace :deputies do

  desc 'open AN JSON and seed DB'
  task :seed => :environment do
    def open_json
      filepath = '../../app/data/AMO10_deputes_actifs_mandats_actifs_organes_XIV.json'
      JSON.parse(File.open(filepath).read)
    end

    def deputies_list
      open_json['export']['acteurs']['acteur'].first
    end

    def create_job_instance
      job_attributes = {
        label: deputies_list['profession']['libelleCourant'],
        category: deputies_list['profession']['socProcINSEE']['catSocPro'],
        family: deputies_list['profession']['socProcINSEE']['famSocPro']
      }
      Job.create(job_attributes)
    end

    def create_deputy_instance
      attributes = {
        civ: deputies_list['etatCivil']['ident']['civ'],
        firstname: deputies_list['etatCivil']['ident']['prenom'],
        lastname: deputies_list['etatCivil']['ident']['nom'],
        birthday: deputies_list['etatCivil']['infoNaissance']['dateNais'],
        birthdep: deputies_list['etatCivil']['infoNaissance']['depNais'],
        job_id: Job.last
      }
      Deputy.create(attributes)
    end

    create_deputy_instance
  end
end
