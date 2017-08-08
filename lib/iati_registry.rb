module IATI
    class Registry
        
        include HTTParty
        base_uri Rails.env.eql?('production') ? 'https://iatiregistry.org/api/action' : 'https://iati-staging.ckan.io/api/action'
        
        # DEFAULT SETTINGS
        PUBLISHER = Rails.configuration.iati_publisher
        APIKEY = Rails.configuration.iati_api_key
        NAME_PREFIX = Rails.configuration.iati_name_prefix
        TITLE_SUFFIX = Rails.configuration.iati_title_suffix
        RESOURCE_BASEURL = Rails.configuration.iati_resource_baseurl
        NOTES = Rails.configuration.iati_dataset_notes
        OWNER_ORG_ID = Rails.configuration.iati_owner_org_id
        PUBLISHER_TITLE = Rails.configuration.iati_publisher_title
        PUBLISHER_EMAIL = Rails.configuration.iati_publisher_email
        IATI_STANDARD_VERSION = Rails.configuration.iati_standard_version
        
        class Sync
            
            def self.all
                result = {
                    :add => { :total => queue[:add].size, :errors => add[:fail] },
                    :remove => { :total => queue[:remove].size, :errors => remove[:fail] },
                    :update => { :total => queue[:update].size, :errors => update[:fail] }
                }
                IatiMailer.sync(PUBLISHER_EMAIL, result).deliver
                result
            end
            
            def self.queue(return_registry_objects=true)
                {   :add => Organization.iati_eligible.has_projects - parent.publisher_datasets,
                    :remove => parent.publisher_datasets - Organization.iati_eligible,
                    :update => calculate_updates(return_registry_objects)
                }
            end
            
            def self.add(orgs=queue[:add])
                results = {:success => [], :fail => []}
                orgs.each do |org|
                    process_response(parent.package_create(parent::Package.new(org).data), results)
                end
                results
            end
            
            def self.remove(orgs=queue[:remove])
                results = {:success => [], :fail => []}
                orgs.each do |org|
                    process_response(parent.package_delete(NAME_PREFIX + org.id.to_s), results)
                end
                results
            end
            
            def self.update(orgs=queue[:update])
                results = {:success => [], :fail => []}
                orgs.each do |org|
                   process_response(parent.package_update(parent::Package.new(org).data), results) 
                end
                results
            end
            
            def self.process_response(request, resultHash)
                if request.code.eql?(200)
                    resultHash[:success] << request
                else
                    resultHash[:fail] << request
                end
            end
            
            private
                
            # TODO Set up touch option on Organization.projects so modifications to an organization's projects updates the Organization's modified attribute. This will catch project deletions that cannot be captured by the below method
            def self.calculate_updates(return_registry_objects=true)
                registry = JSON.parse(parent.publisher_datasets(:mapped => false))['result']['results']
                queue = []
                registry.each do |reg|
                    id = reg['url'].split('/').last
                    nam = Organization.find(id)
                    obj = return_registry_objects.eql?(true) ? reg : nam
                    if nam.projects.size > 0
                        registry_freshest = DateTime.parse(reg['resources'].first['last_modified'])
                        ngoaidmap_freshest = DateTime.parse(Project.organizations(nam.id).order('updated_at desc').first.updated_at.strftime("%FT%T"))
                        queue << obj if (ngoaidmap_freshest - registry_freshest) > 0
                    end
                end
                queue
            end
        end
        
        class << self
            
            def publisher_datasets(options={})
                options = {:org => PUBLISHER, :mapped => true}.merge(options)
                
                # This method is not designed to page through result sets greater than 1000
                params = {:rows=>1000, :q=>"organization:#{options[:org]}"}
                
                results = Rails.cache.fetch("package_search/#{params.to_s}", :compress => true, :expires_in => 12.hours) do
                    package_search(params).to_json
                end
                
                ids = []
                JSON.parse(results)['result']['results'].each do |r|
                   ids << r['url'].split('/').last.to_i 
                end
                if options[:mapped].eql?(true)
                    Organization.where(:id => ids).order(:name)
                else
                    results
                end
            end
            
            
            protected
            
            def package_create(pkg={})
                self.post("/package_create", {:body => pkg.to_json, :headers => headers}) 
            end
            
            def package_search(params={})
                self.get("/package_search", :query => params) 
            end
            
            def package_delete(id)
                self.post("/package_delete", {:body => {:id => id}.to_json, :headers => headers }) unless id.nil?
            end
            
            def package_update(pkg={})
                self.post("/package_update", {:body => pkg.to_json, :headers => headers})
            end
            
            private
            def headers(additional={})
                {
                    'Authorization' => Rails.configuration.iati_api_key,
                    'Content-Type' => 'application/json'
                }.merge(additional)
            end
        end
        
        class Package 
            
            def data 
                @object
            end
            
            def initialize(org)
                
                id = org['url'].split('/').last unless org.class.eql?(Organization)
                
                # If not Organization instance, create one
                nam = org.class.eql?(Organization) ? org : Organization.find(id)
                
                # Fields to set for new and updated projects
                @object = {
                    'name' => NAME_PREFIX + nam.id.to_s,
                    'title' => nam.name + TITLE_SUFFIX,
                    'url' => RESOURCE_BASEURL + nam.id.to_s,
                    'resources' => [
                        {   'url' => RESOURCE_BASEURL + nam.id.to_s,
                            'mimetype' => 'application/xml',
                            'last_modified' => nam.projects.by_last_updated.first.updated_at.strftime('%FT%T'),
                            'format' => 'iati-xml'
                        }
                    ],
                    'notes' => NOTES,
                    'state' => 'active',
                    'owner_org' => OWNER_ORG_ID,
                    'author' => PUBLISHER_TITLE,
                    'author_email' => PUBLISHER_EMAIL,
                    # the following attributes get auto converted to extras by ckan API
                    'activity_count' => nam.projects.size,
                    'data_updated' => nam.projects.by_last_updated.first.updated_at.strftime('%FT%T'),
                    'filetype' => 'activity',
                    'language' => 'en',
                    'secondary_publisher' => nam.name,
                    # iati_version is not auto-converted, so manually add to extras
                    'extras' => [
                        {   'key' => 'iati_version',
                            'value' => IATI_STANDARD_VERSION
                        }
                    ]
                         
                }
                
                # For handling existing registry packages
                unless org.class == Organization
                    @object = org.merge(@object)
                end
            end
        end
    end
end