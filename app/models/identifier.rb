class Identifier < ActiveRecord::Base
    
    belongs_to :identifiable, :polymorphic => true
    
    validates_presence_of :identifier, :assigner_org_id
    validates_uniqueness_of :identifier, :scope => [:assigner_org_id]
    
    
end
