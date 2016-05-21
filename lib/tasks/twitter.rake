namespace :twitter do

  desc 'call API and get basic infos into deputies instances'
  task :seed_deputies => :environment do

    def stringify_screen_names
      screen_names = Deputy.where.not(screen_name: nil).map(&:screen_name)
      result = Array.new
      while screen_names.length >= 100
        result << screen_names.slice!(0,100).join(',')
      end
      result << screen_names.join(',') unless screen_names.empty?
    end


  end

end

