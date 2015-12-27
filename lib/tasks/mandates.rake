namespace :mandates do

  desc 'open AN JSON and seed organes'
  task :organes => :environment do
    def open_json
      filepath = 'app/data/AMO10_deputes_actifs_mandats_actifs_organes_XIV.json'
      JSON.parse(File.open(filepath).read)
    end

    def create_organe_instance(organe)
      attributes = {
        original_tag: organe['uid'],
        label: organe['libelle'],
        current: organe['viMoDe']['dateFin'].nil?
      }
      Organe.create(attributes)
    end

    def run
      puts 'Seed starting'
      x = 1
      open_json['export']['organes']['organe'].each do |organe|
        print "Seeding organe ##{x}: "
        create_organe_instance(organe)
        puts 'done'
        x += 1
      end
      puts 'Done!'
    end

    run
  end

end
