namespace :iom do
  namespace :projects do

    desc 'Seed existing global projects with new global geolocation'
    
    task :add_global_geolocation => :environment do
            
        Project.where(:geographical_scope => 'global').each do |p|
		p.save!
		puts "saved #{p.id}"
		puts p.geolocations
        end

    end
  end
end
