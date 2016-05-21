namespace :twitter do

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
      attr = {
        twid: data[:id_str],
        followers: { Date.today => data[:followers_count] }.to_json,
        followings: { Date.today => data[:friends_count] }.to_json,
        tweets: { Date.today => data[:statuses_count] }.to_json,
        lists: { Date.today => data[:listed_count] }.to_json,
        favourites: { Date.today => data[:favourites_count] }.to_json,
        creation_date: data[:created_at],
        verified: data[:verified],
        description: data[:description],
        profile_picture: data[:profile_image_url_https].gsub('normal', '400x400'),
        screen_name_valid: true
      }
      Deputy.find_by(screen_name: data[:screen_name]).update_attributes(attr)
    end

    def scan_for_invalid_screen_name(total, subtotal)
      puts 'Starting to scan for invalid screen_name'
      Deputy.where(screen_name_valid: nil).where.not(screen_name: "").each do |deputy|
        print "Deputy with screen_name error ##{subtotal}/#{total}: "
        deputy.screen_name_valid = false
        deputy.save
        puts 'done'
        subtotal += 1
      end
      return subtotal
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

end



