class Geolocation < ActiveRecord::Base
  has_and_belongs_to_many :projects

  scope :active, lambda {joins(:projects).where("projects.end_date is null or (projects.end_date > ? AND projects.start_date < ?)", Date.today.to_s(:db), Date.today.to_s(:db))}
  scope :closed, lambda {joins(:projects).where("projects.end_date < ?", Date.today.to_s(:db))}
  scope :organizations, lambda{|orgs| joins(:projects).joins('INNER JOIN organizations on projects.primary_organization_id = organizations.id').where(:organizations => {:id => orgs})}

  before_save :set_readable_path
  
  def self.fetch_all(level, geolocation)
    level ||= 0
    geolocations = Geolocation.where('adm_level = ?', level)
    superlevel  = level.to_i - 1
    geolocations = geolocations.where("g#{superlevel} = ?", geolocation) if geolocation.present? && level.to_i >= 0
    geolocations.order(:name)
  end
  
  def self.project_count_by_country
      order("count desc, country_name").
      group(:country_name, :country_code).
      select("country_name, country_code, count(distinct project_id)")
  end
  
  def self.countries
     where(:adm_level => 0)
  end
  
  def set_readable_path
    self.readable_path = [self.g0, self.g1, self.g2, self.g3, self.g4].compact.map{|g| Geolocation.where(:uid => g).first.try(:name)}.compact.reject{ |x| x.strip.empty? }.join('>')
  end
  
  def self.get_select_values
     countries.select('uid, name').order('name asc').collect{ |g| [g.name, g.uid] } 
  end

  def reassign_projects(to_geolocation)
    if to_geolocation.is_a?(Geolocation)
      transaction do
        projects_to_move = self.projects
        to_geolocation.projects << projects_to_move
        self.projects.clear
      end
    else
      false
    end
  end
end
