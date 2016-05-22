namespace :twitter do

  desc 'seed DB by calling all twitter seeding rake tasks'
  task :seed => :environment do
    Rake::Task['twitter:seed_deputies'].invoke
  end

  desc 'call API and get basic infos into deputies instances'
  task :seed_deputies => :environment do

    def stringify_screen_names
      screen_names = Deputy.where.not(screen_name: "").map(&:screen_name)
      result = Array.new
      while screen_names.length >= 100
        result << screen_names.slice!(0,100).join(',')
      end
      result << screen_names.join(',') unless screen_names.empty?
    end

    def call_API screen_names_string
      path = "https://api.twitter.com/1.1/users/lookup.json?screen_name=#{screen_names_string}"
      Twitter::REST::Request.new($twitter, 'get', path).perform
    end

    def update_deputy data
      deputy = Deputy.find_by(screen_name: data[:screen_name].downcase)
      attr = {
        twid:              data[:id_str],
        creation_date:     data[:created_at],
        verified:          data[:verified],
        description:       data[:description],
        profile_picture:   data[:profile_image_url_https].gsub('normal', '400x400'),
        screen_name_valid: true
      }
      deputy.update_attributes(attr)

      equivalences = {
        followers:  :followers_count,
        followings: :friends_count,
        tweets:     :statuses_count,
        lists:      :listed_count,
        favourites: :favourites_count
      }
      update_json_attributes(deputy, data, equivalences)
    end

    def update_json_attributes(deputy, data, equivalences)
      equivalences.keys.each do |key|
        if deputy[key].nil?
          deputy.update_attributes(key => { Date.today.to_s => data[equivalences[key]] })
        else
          deputy[key][Date.today.to_s] = data[equivalences[key]]
          deputy.save
        end
      end
    end

    def scan_for_invalid_screen_name(total, subtotal)
      puts 'Starting to scan for invalid screen_name'
      deputies = Deputy.where(screen_name_valid: nil).where.not(screen_name: "")
      Deputy.where(screen_name_valid: false).each do |deputy|
        deputies << deputy
      end
      deputies.each do |deputy|
        print "Deputy with screen_name error ##{subtotal}/#{total}: "
        deputy.screen_name_valid = false
        deputy.save
        puts 'done'
        subtotal += 1
      end
      return subtotal - 1
    end

    def run
      total = Deputy.where.not(screen_name: "").count
      puts 'Seed starting'
      subtotal = 1
      stringify_screen_names.each do |screen_names_string|
        call_API(screen_names_string).each do |twitter_data|
          print "Twitter data for deputy ##{subtotal}/#{total}: "
          update_deputy(twitter_data)
          puts 'done'
          subtotal += 1
        end
      end
      result = scan_for_invalid_screen_name(total, subtotal)
      puts "Done! #{result} out of #{total} seeded"
    end

    run
  end

  desc 'prompt console for missing screen_names and register given ones'
  task :manual_screen_names => :environment do

    def run
      deputies = Deputy.where(screen_name_valid: false)
      total = deputies.count
      subtotal = 0
      deputies.each do |deputy|
        subtotal += 1
        puts "Deputy ##{subtotal} out of #{total}: #{deputy.full_name}"
        print "Screen name: "
        screen_name = STDIN.gets.chomp
        if screen_name.length > 1
          deputy.screen_name = screen_name.downcase
          deputy.screen_name_valid = true
          deputy.save
          puts "Saved! Screen_name : #{deputy.screen_name}"
        elsif screen_name == "q"
          puts "See you next time!"
          break
        else
          puts "No screen_name added"
        end
      end
    end

    run
  end
end



