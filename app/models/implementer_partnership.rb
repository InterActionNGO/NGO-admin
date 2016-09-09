class ImplementerPartnership < ActiveRecord::Base
  belongs_to :implementer, :class_name => 'Organization'
  belongs_to :project

  validates_presence_of :implementer, :project
end
