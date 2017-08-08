class Admin::IatiController < Admin::AdminController
    
    layout 'admin_iati_layout'
    
    def index
    end
    
    def publisher
        @toPublish = IATI::Registry::Sync.queue[:add]
        @toUnpublish = IATI::Registry::Sync.queue[:remove]
        @toUpdate = IATI::Registry::Sync.queue(false)[:update]
#         @revision_history = revision_history
#         @org_registry_data = organization_registry_data
    end
    
    def sync
        IATI::Registry::Sync.all
        flash[:notice] = 'Sync complete. Results emailed.'
        redirect_to :controller => :iati, :action => 'publisher'
        
    end
    
    def published_organizations
        render :json => IATI::Registry.publisher_datasets
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
    
    
end
