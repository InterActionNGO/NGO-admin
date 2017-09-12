class HumanitarianScopeType < ActiveRecord::Base
  validates :name,
            :code,
            :presence => true,
            :uniqueness => { :case_sensitive => false }
end
