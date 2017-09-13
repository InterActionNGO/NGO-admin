class HumanitarianScopeVocabulary < ActiveRecord::Base
  validates :name,
            :code,
            :presence => true,
            :uniqueness => { :case_sensitive => false }

  def to_s
    "#{name} (#{code})"
  end
  alias :display_name :to_s
end
