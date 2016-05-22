require 'csv'

namespace :deputies do
  desc 'seed DB by calling all deputies rake tasks'
  task :seed => :environment do
    Rake::Task['deputies:deputies'].invoke
    Rake::Task['deputies:add_screen_names'].invoke
  end

  desc 'open AN JSON and seed DB'
  task :deputies => :environment do
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
      search_job = Job.where(attributes)
      Job.create(attributes) if search_job.empty?
      @job = search_job.first
    end

    def create_deputy_instance(deputy)
      status = deputy['etatCivil']
      attributes = {
        civ: status['ident']['civ'],
        firstname: status['ident']['prenom'],
        lastname: status['ident']['nom'],
        birthday: status['infoNaissance']['dateNais'],
        birthdep: status['infoNaissance']['depNais'],
        job_id: @job.id,
        original_tag: deputy['uid']['#text']
      }
      find_deputy = Deputy.find_by(original_tag: deputy['uid']['#text'])
      if find_deputy
        find_deputy.update_attributes(attributes)
      else
        Deputy.create(attributes)
      end
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
      find_address = Address.find_by(original_tag: address['uid'])
      if find_address
        find_address.update_attributes(attributes)
      else
        Address.create(attributes)
      end
    end

    def create_e_address_instance(address)
      attributes = {
        label: address['typeLibelle'],
        value: address['valElec'],
        deputy_id: Deputy.last.id
      }
      search_e_address = EAddress.where(attributes)
      EAddress.create(attributes) if search_e_address.nil?
    end

    def create_phone_instance(address)
      find_linked_address = Address.find_by(original_tag: address['adresseDeRattachement'])
      find_blank_address = Address.where(deputy_id: Deputy.last.id).where(label: 'NR')
      if find_linked_address
        attached = find_linked_address
      elsif find_blank_address.any?
        attached = find_blank_address.first
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
      search_phone = Phone.where(attributes)
      Phone.create(attributes) if search_phone.empty?
    end

    def run
      puts 'Seed starting'
      x = 1
      open_json['export']['acteurs']['acteur'].each do |deputy|
        print "Seeding deputy ##{x}: "
        create_job_instance(deputy)
        create_deputy_instance(deputy)
        dispatch_address_info(deputy)
        puts 'done'
        x += 1
      end
      puts 'Done!'
    end

    run
  end

  desc 'open my CSV and seed screen_names'
  task :add_screen_names => :environment do

    def run
      puts 'Twitter seed starting'
      x = 1
      csv_options = { col_sep: ',', quote_char: '"', headers: :first_row }
      filepath = 'app/data/screen_names.csv'
      CSV.foreach(filepath, csv_options) do |row|
        print "Twitter for deputy ##{x}: "
        deputy = Deputy.where(lastname: row['Nom'], firstname: row['Prénom']).first
        unless deputy.nil?
          deputy.screen_name = row['At'].to_s.downcase
          deputy.save
        end
        puts 'done'
        x += 1
      end
      puts 'Done!'
    end

    run
  end

  desc 'save the modified values in another CSV'
  task :save_screen_names => :environment do

    def run
      puts 'Saving...'
      csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
      filepath = 'app/data/screen_names.csv'
      CSV.open(filepath, 'wb', csv_options) do |row|
        row << ['Prénom', 'Nom', 'At']
        x = 1
        Deputy.order(:lastname).each do |deputy|
          print "Saving deputy ##{x}: "
          row << [deputy.firstname, deputy.lastname, deputy.screen_name]
          puts 'done'
          x += 1
        end
      end
      puts 'Done!'
    end

    run
  end
end
