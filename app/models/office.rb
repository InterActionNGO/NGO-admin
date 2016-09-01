class Office < ActiveRecord::Base
  belongs_to :organization
  has_many :donations
  has_many :projects, :through => :donations
  has_many :all_donated_projects, :through => :donations, :source => :project, :uniq => true

  validates_presence_of :name
end
