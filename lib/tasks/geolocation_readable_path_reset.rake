namespace :iom do
  namespace :projects do

    desc 'Resave all geolocations, resetting the readable paths'
    
    task :geolocation_readable_path_reset => :environment do
            
        Geolocation.find_each do |g|
            g.save
        end

    end
  end
end
