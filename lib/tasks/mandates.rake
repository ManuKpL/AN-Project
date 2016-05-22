namespace :mandates do
  desc 'seed DB by calling all mandates rake tasks'
  task :seed => :environment do
    Rake::Task['mandates:organes'].invoke
    Rake::Task['mandates:mandates'].invoke
    Rake::Task['mandates:groups'].invoke
    # Rake::Task['mandates:functions'].invoke
  end

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
      find_organe = Organe.find_by(original_tag: organe['uid'])
      if find_organe
        find_organe.update_attributes(attributes)
      else
        Organe.create(attributes)
      end
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

  desc 'open AN JSON and seed deputies mandates'
  task :mandates => :environment do
    def open_json
      filepath = 'app/data/AMO10_deputes_actifs_mandats_actifs_organes_XIV.json'
      JSON.parse(File.open(filepath).read)
    end

    def find_deputy_instance(deputy)
      Deputy.find_by(original_tag: deputy['uid']['#text'])
    end

    def find_circonscription_instance(mandate)
      location = mandate['election']['lieu']
      department_num = location['numDepartement'] == '099' ? '99' : location['numDepartement']
      attributes = {
        former_region: location['region'],
        department: location['departement'],
        department_num: department_num,
        circo_num: location['numCirco']
      }
      Circonscription.create(attributes) if Circonscription.where(attributes).empty?
      return Circonscription.where(attributes).first
    end

    def create_mandate_instance(mandate, deputy)
      if mandate['suppleants'].nil?
        substitute_tag = mandate['mandature']['mandatRemplaceRef']
      else
        substitute_tag = mandate['suppleants']['suppleant']['suppleantRef']
      end
      attributes = {
        deputy_id: find_deputy_instance(deputy).id,
        original_tag: mandate['uid'],
        substitute: mandate['mandature']['mandatRemplaceRef'].nil?,
        substitute_original_tag: substitute_tag,
        starting_date: mandate['dateDebut'],
        reason: mandate['election']['causeMandat'],
        circonscription_id: find_circonscription_instance(mandate).id,
        seat_num: mandate['mandature']['placeHemicycle'].to_i,
        hatvp_page: mandate['InfosHorsSIAN']['HATVP_URI']
      }
      find_mandate = Mandate.find_by(original_tag: mandate['uid'])
      if find_mandate
        find_mandate.update_attributes(attributes)
      else
        Mandate.create(attributes)
      end
    end

    def run
      puts 'Seed starting'
      x = 1
      open_json['export']['acteurs']['acteur'].each do |deputy|
        print "Seeding for deputy ##{x}. "
        deputy['mandats']['mandat'].each do |mandate|
          unless mandate['election'].nil? || mandate['election']['lieu']['region'].nil?
            print "Creating mandate: "
            create_mandate_instance(mandate, deputy)
            puts 'done'
          end
        end
        x += 1
      end
      puts 'Done!'
    end

    run
  end

  desc 'open AN JSON and seed GP for each deputy'
  task :groups => :environment do
    def open_json
      filepath = 'app/data/AMO10_deputes_actifs_mandats_actifs_organes_XIV.json'
      JSON.parse(File.open(filepath).read)
    end

    def find_organe_instance(mandate)
      Organe.find_by(original_tag: mandate['organes']['organeRef'])
    end

    def find_deputy_instance(deputy)
      Deputy.find_by(original_tag: deputy['uid']['#text'])
    end

    def siglify(label)
      if label == 'Écologiste'
        return label
      else
        result = []
        label.scan(/[\wàÀâÂäÄéÉèÈêÊëËìÌîÎïÏòÒôÔöÖùÙûÛüÜ]+/).each do |word|
          result << word[0].capitalize if word.length > 2 && word != 'des'
        end
        return result.join('')
      end
    end

    def find_group_instance(organe)
      attributes = {
        sigle: siglify(organe.label),
        organe_id: organe.id
      }
      Group.create(attributes) if Group.where(attributes).empty?
      return Group.where(attributes).first
    end

    def run
      puts 'Seed starting'
      x = 1
      open_json['export']['acteurs']['acteur'].each do |deputy|
        print "Seeding for deputy ##{x}. "
        deputy['mandats']['mandat'].each do |mandate|
          organe = find_organe_instance(mandate)
          if mandate['typeOrgane'] == 'GP' && organe.current && mandate['infosQualite']['codeQualite'] != 'Président'
            print "Creating GP: "
            deputy_instance = find_deputy_instance(deputy)
            deputy_instance.group_id = find_group_instance(organe).id
            deputy_instance.save
            puts 'done'
          end
        end
        x += 1
      end
      puts 'Done!'
    end

    run
  end

  desc 'open AN JSON and seed functions other than mandates and GP'
  task :functions => :environment do
    def open_json
      filepath = 'app/data/AMO10_deputes_actifs_mandats_actifs_organes_XIV.json'
      JSON.parse(File.open(filepath).read)
    end

    def find_deputy_instance(deputy)
      Deputy.find_by(original_tag: deputy['uid']['#text'])
    end

    def find_organe_instance(function)
      Organe.find_by(original_tag: function['organes']['organeRef'])
    end

    def create_function_instance(function, deputy)
      attributes = {
        original_tag: function['uid'],
        starting_date: function['dateDebut'],
        status: function['infosQualite']['libQualiteSex'],
        organe_type: function['typeOrgane'],
        deputy_id: find_deputy_instance(deputy).id,
        organe_id: find_organe_instance(function).id
      }
      Function.create(attributes)
    end

    def run
      puts 'Seed starting'
      x = 1
      open_json['export']['acteurs']['acteur'].each do |deputy|
        print "Seeding for deputy ##{x}: "
        y = 1
        deputy['mandats']['mandat'].each do |function|
          if function['election'].nil? || function['election']['lieu']['region'].nil?
            unless mandate['typeOrgane'] == 'GP' && find_organe_instance(mandate).current && mandate['infosQualite']['codeQualite'] != 'Président'
              create_function_instance(function, deputy)
              y += 1
            end
          end
        end
        puts "#{y} functions done"
        x += 1
      end
      puts 'Done!'
    end

    # NB: not a priority
    # run
  end
end
