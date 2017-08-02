class Admin::IatiController < Admin::AdminController
    
    layout 'admin_iati_layout'
    
    def index
    end
    
    def publish
        @toPublish = Organization.iati_eligible - published
        @toUnpublish = toUnpublish
        @toUpdate = toUpdate
#         @revision_history = revision_history
#         @org_registry_data = organization_registry_data
    end
    
    def eligible
        render :json => Organization.iati_eligible
    end
    
    def published
        
        render :json => published
        
    end
    
    private
    
    def organization_registry_data
        url = 'https://iatiregistry.org/api/action/organization_show?id=ia_nam'
        json = JSON.parse(HTTParty.get(url).body)
        if json['success'] == true
            json['result']
        else
            []
        end
    end
    
    def revision_history
        url = 'https://iatiregistry.org/api/action/organization_revision_list?id=ia_nam'
        json = JSON.parse(HTTParty.get(url).body)
        if json['success'] == true
            json['result']
        else
            []
        end
    end
    
    def toUnpublish
        published - Organization.iati_eligible
    end
    
    def toUpdate
       set1 = published - toUnpublish
       []
    end
    
    def published
        
        url = 'https://iatiregistry.ckan.io/api/action/package_search?rows=1000&q=organization:ia_nam'
        json = JSON.parse(HTTParty.get(url).body)
        results = json['result']['results']
        ids = []
        results.each do |r|
            ids << r['url'].split('/').last.to_i
        end
        Organization.where(:id => ids)
    end
    
end
