namespace :iom do
   namespace :iati do
      
       desc 'Sync registry with ngoaidmap'
       task :sync => :environment do
            IATI::Registry::Sync.all
       end
   end
end