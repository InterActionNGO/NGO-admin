class HumanitarianScopeVocabulary < ActiveRecord::Base
  validates :name,
            :code,
            :presence => true,
            :uniqueness => { :case_sensitive => false }
end
