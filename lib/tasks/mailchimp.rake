namespace :iom do
   namespace :mailchimp do
      
       desc 'Sync mailchimp data contact list with ngoaidmap'
       task :sync => :environment do
            g = Gibbon::API.new # initialize mailchimp api wrapper
            id = "02b981eb9e" # data contact list id in mailchimp
            
            # NGO Aid Map list
            nam_data_contacts = Organization.interaction_members.map { |m| [m.main_data_contact_name.split(" ")[0], m.main_data_contact_email] }.reject { |i| i[1].empty? }
            
            # MailChimp List
            mc_data_contacts = g.lists.members({:id => id})['data'].map { |m| [m['merges']['FNAME'], m['merges']['EMAIL']] }
            
            to_add = []
            to_remove = []
            
            nam_data_contacts.each do |c|
                present = mc_data_contacts.select { |x| x[1] == c[1] }
                to_add << c if present.empty?
            end
            
            mc_data_contacts.each do |c|
                absent = nam_data_contacts.select { |x| x[1] == c[1] }
                to_remove << c if absent.empty?
            end
            
            to_add.each do |c|
                name = c[0].present? ? c[0].split(" ") : ["",""]
                formatted = {
                    :id => id,
                    :email => { :email => c[1] },
                    :merge_vars => { :FNAME => name[0], :LNAME => name[1,name.size].join(" ") },
                    :double_optin => false
                }
                puts g.lists.subscribe(formatted)
                                   
            end
                
            to_remove.each do |c|
                puts g.lists.unsubscribe(:id => id, :email => { :email => c[1] }, :delete_member => true, :send_notify => false)
            end
            
            puts 'All done!'
       end
   end
end