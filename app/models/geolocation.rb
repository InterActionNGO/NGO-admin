class Geolocation < ActiveRecord::Base
  has_and_belongs_to_many :projects
  def self.fetch_all(level, geolocation)
    level ||= 0
    geolocations = Geolocation.where('adm_level = ?', level)
    superlevel  = level.to_i - 1
    geolocations = geolocations.where("g#{superlevel} = ?", geolocation) if geolocation.present? && level.to_i >= 0
    geolocations.order(:name)
  end
end
