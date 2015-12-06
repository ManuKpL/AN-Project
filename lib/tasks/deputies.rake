namespace :deputies do

  desc 'open AN JSON and seed DB'
  task :seed => :environment do
    def open_json
      filepath = 'app/data/AMO10_deputes_actifs_mandats_actifs_organes_XIV.json'
      JSON.parse(File.open(filepath).read)
    end

    def create_job_instance(deputy)
      job = deputy['profession']
      attributes = {
        label: job['libelleCourant'],
        category: job['socProcINSEE']['catSocPro'],
        family: job['socProcINSEE']['famSocPro']
      }
      Job.create(attributes)
    end

    def create_deputy_instance(deputy)
      status = deputy['etatCivil']
      attributes = {
        civ: status['ident']['civ'],
        firstname: status['ident']['prenom'],
        lastname: status['ident']['nom'],
        birthday: status['infoNaissance']['dateNais'],
        birthdep: status['infoNaissance']['depNais'],
        job_id: Job.last.id,
        original_tag: deputy['uid']['#text']
      }
      Deputy.create(attributes)
    end

    def dispatch_address_info(deputy)
      phone = []
      deputy['adresses']['adresse'].each do |e|
        create_address_instance(e) unless e['intitule'].nil?
        create_e_address_instance(e) unless e['valElec'].nil?
        phone << e unless e['typeLibelle'].match(/Télé/).nil?
      end
      phone.each do |e|
        create_phone_instance(e)
      end
    end

    def create_address_instance(address)
      attributes = {
        label: address['typeLibelle'],
        description: address['intitule'],
        value: "#{address['numeroRue']}, #{address['nomRue']}",
        more_info: address['complementAdresse'],
        postcode: address['codePostal'],
        city: address['ville'],
        original_tag: address['uid'],
        deputy_id: Deputy.last.id
      }
      Address.create(attributes)
    end

    def create_e_address_instance(address)
      attributes = {
        label: address['typeLibelle'],
        value: address['valElec'],
        deputy_id: Deputy.last.id
      }
      EAddress.create(attributes)
    end

    def create_phone_instance(address)
      attributes = {
        label: address['typeLibelle'],
        value: address['numeroTelephone'],
        address_id: Address.find_by_original_tag(address['adresseDeRattachement']).id
      }
      Phone.create(attributes)
    end

    def run
      open_json['export']['acteurs']['acteur'].each do |deputy|
        create_job_instance(deputy)
        create_deputy_instance(deputy)
        dispatch_address_info(deputy)
      end
    end

    run
  end
end
