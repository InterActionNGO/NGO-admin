class Partnership < ActiveRecord::Base
  belongs_to :partner, :class_name => 'Organization'
  belongs_to :project

  validates_presence_of :partner, :project
end
