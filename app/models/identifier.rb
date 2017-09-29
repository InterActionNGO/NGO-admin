class Identifier < ActiveRecord::Base
    
    belongs_to :identifiable, :polymorphic => true
    
    validates_presence_of :identifier, :assigner_org_id
    validates_uniqueness_of :identifier, :scope => [:assigner_org_id]
    
    before_destroy :remove_org_id
    
    private
    
    def remove_org_id
        if self.identifiable_type == "Project" && self.assigner_org_id == self.identifiable.primary_organization_id
            self.identifiable.update_attribute('organization_id', nil)
        end
    end
end
