namespace :deputies do

  desc 'open AN JSON and seed DB'
  task :seed => :environment do
    def open_json
      filepath = 'app/data/AMO10_deputes_actifs_mandats_actifs_organes_XIV.json'
      JSON.parse(File.open(filepath).read)
    end

    def create_job_instance(deputy)
      job = deputy['profession']
      if job['libelleCourant'].nil?
        attributes = {
          label: 'NR',
          category: 'NR',
          family: 'NR'
        }
      else
        attributes = {
          label: job['libelleCourant'],
          category: job['socProcINSEE']['catSocPro'],
          family: job['socProcINSEE']['famSocPro']
        }
      end
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

    def set_value(address)
      if address['nomRue'].nil?
        return 'NR'
      elsif address['numeroRue'].nil?
        return address['nomRue']
      else
        return "#{address['numeroRue']}, #{address['nomRue']}"
      end
    end

    def create_address_instance(address)
      attributes = {
        label: address['typeLibelle'],
        description: address['intitule'],
        value: set_value(address),
        more_info: address['complementAdresse'],
        postcode: address['codePostal'],
        city: address['ville'],
        original_tag: address['uid'],
        deputy_id: Deputy.last.id
      }
      attributes[:value].chop! if attributes[:value][-1] == ","
      attributes[:description].chop! if attributes[:description][-1] == ","
      attributes[:more_info].chop! if attributes[:more_info] != nil && attributes[:more_info][-1] == ","
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
      if Address.find_by_original_tag(address['adresseDeRattachement'])
        attached = Address.find_by_original_tag(address['adresseDeRattachement'])
      elsif Address.where(deputy_id: Deputy.last.id).where(label: 'NR') != []
        attached = Address.where(deputy_id: Deputy.last.id).where(label: 'NR').first
      else
        attributes = {
          label: 'NR',
          description: 'NR',
          value: 'NR',
          more_info: 'NR',
          postcode: 'NR',
          city: 'NR',
          original_tag: 'NR',
          deputy_id: Deputy.last.id
        }
        Address.create(attributes)
        attached = Address.last
      end
      attributes = {
        label: address['typeLibelle'],
        value: address['numeroTelephone'],
        address_id: attached.id
      }
      Phone.create(attributes)
    end

    def run
      puts 'Seed starting'
      x = 1
      open_json['export']['acteurs']['acteur'].each do |deputy|
        print "Seeding deputy ##{x}: "
        create_job_instance(deputy)
        create_deputy_instance(deputy)
        dispatch_address_info(deputy)
        puts "done"
        x += 1
      end
      puts "Done!"
    end

    run
  end
end
