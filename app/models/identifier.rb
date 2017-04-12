class Identifier < ActiveRecord::Base
    
#     include ModelChangesRecorder
    
    belongs_to :identifiable, :polymorphic => true
    
    validates_presence_of :identifier, :assigner_org_id, :identifiable_id, :identifiable_type
    validates_uniqueness_of :identifier, :scope => [:assigner_org_id]
    
    
end
