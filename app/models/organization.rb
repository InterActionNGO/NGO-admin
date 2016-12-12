# == Schema Information
#
# Table name: organizations
#
#  id                              :integer         not null, primary key
#  name                            :string(255)
#  description                     :text
#  budget                          :float
#  website                         :string(255)
#  national_staff                  :integer
#  twitter                         :string(255)
#  facebook                        :string(255)
#  hq_address                      :string(255)
#  contact_email                   :string(255)
#  contact_phone_number            :string(255)
#  donation_address                :string(255)
#  zip_code                        :string(255)
#  city                            :string(255)
#  state                           :string(255)
#  donation_phone_number           :string(255)
#  donation_website                :string(255)
#  site_specific_information       :text
#  created_at                      :datetime
#  updated_at                      :datetime
#  logo_file_name                  :string(255)
#  logo_content_type               :string(255)
#  logo_file_size                  :integer
#  logo_updated_at                 :datetime
#  international_staff             :string(255)
#  contact_name                    :string(255)
#  contact_position                :string(255)
#  contact_zip                     :string(255)
#  contact_city                    :string(255)
#  contact_state                   :string(255)
#  contact_country                 :string(255)
#  donation_country                :string(255)
#  estimated_people_reached        :integer
#  private_funding                 :float
#  usg_funding                     :float
#  other_funding                   :float
#  private_funding_spent           :float
#  usg_funding_spent               :float
#  other_funding_spent             :float
#  spent_funding_on_relief         :float
#  spent_funding_on_reconstruction :float
#  percen_relief                   :integer
#  percen_reconstruction           :integer
#  media_contact_name              :string(255)
#  media_contact_position          :string(255)
#  media_contact_phone_number      :string(255)
#  media_contact_email             :string(255)
#

class Organization < ActiveRecord::Base
  include ModelChangesRecorder

  has_many :resources, :conditions => 'resources.element_type = #{Iom::ActsAsResource::ORGANIZATION_TYPE}', :foreign_key => :element_id, :dependent => :destroy
  has_many :media_resources, :conditions => 'media_resources.element_type = #{Iom::ActsAsResource::ORGANIZATION_TYPE}', :foreign_key => :element_id, :dependent => :destroy, :order => 'position ASC'
  has_many :projects, :foreign_key => :primary_organization_id

  has_attached_file :logo, :styles => {
                                      :small => {
                                        :geometry => "80x46>",
                                        :format => 'jpg'
                                      },
                                      :medium => {
                                        :geometry => "200x150>",
                                        :format => 'jpg'
                                      }
                                    },
                            :url => "/system/:attachment/:id/:style.:extension"

  has_many :sites, :foreign_key => :project_context_organization_id
  has_many :donations, :through => :projects
  has_many :donations_made, :foreign_key => :donor_id, :dependent => :destroy, :class_name => "Donation"
  has_many :offices, :dependent => :destroy
  has_many :all_donated_projects, :through => :donations_made, :source => :project, :uniq => true
  has_one :user

  scope :with_donations, joins(:donations_made)
  scope :active_donated_projects, lambda { joins(:donations_made => :project).where("projects.end_date IS NULL OR (projects.end_date > ? AND projects.start_date <= ?)", Date.today.to_s(:db), Date.today.to_s(:db)) }

  accepts_nested_attributes_for :user, :reject_if => proc {|a| a['email'].blank?}, :allow_destroy => true

  before_save :check_user_valid
  before_save :set_org_type_code
  before_save :set_budget_usd

  validates_format_of :website, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix, :message => "URL is invalid (your changes were not saved). Make sure the web address begins with 'http://' or 'https://'.", :allow_blank => true, :if => :website_changed?
  validates_format_of :donation_website, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix, :message => "URL is invalid (your changes were not saved). Make sure the web address begins with 'http://' or 'https://'.", :allow_blank => true, :if => :donation_website_changed?
  validates_format_of :facebook, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix, :message => "URL is invalid (your changes were not saved). Make sure the web address begins with 'http://' or 'https://'.", :allow_blank => true, :if => :facebook_changed?
  validates_format_of :twitter, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix, :message => "URL is invalid (your changes were not saved). Make sure the web address begins with 'http://' or 'https://'.", :allow_blank => true, :if => :twitter_changed?

  validates_presence_of :name
  validates_uniqueness_of :organization_id


  serialize :site_specific_information

  before_validation :strip_urls

  def strip_urls
    if self.website.present?
      self.website = self.website.strip
    end
    if self.donation_website.present?
      self.donation_website = self.donation_website.strip
    end
    if self.twitter.present?
      self.twitter = self.twitter.strip
    end
    if self.facebook.present?
      self.facebook = self.facebook.strip
    end
  end

  def all_active_partners_and_donors
    [
      projects.active.map(&:partners),
      projects.active.map(&:donors)
    ].flatten.compact.uniq
  end

  def all_closed_partners_and_donors
    [
      projects.closed.map(&:partners),
      projects.closed.map(&:donors)
    ].flatten.compact.uniq
  end


  # Attributes for site getter
  def attributes_for_site(site)
    atts = site_specific_information || {}
    if atts[site.id.to_s]
      atts[site.id.to_s].reject{|key,value| value.nil? }
    else
      atts[site.id.to_s] = {}
      atts[site.id.to_s]
    end
  end

  # Attributes for site setter
  def attributes_for_site=(value)
    atts = site_specific_information || {}
    atts[value[:site_id].to_s] = value[:organization_values]

    # Funding values set to float
    if atts[value[:site_id].to_s][:usg_funding]
      if atts[value[:site_id].to_s][:usg_funding].is_a?(String)
        atts[value[:site_id].to_s][:usg_funding] = atts[value[:site_id].to_s][:usg_funding].delete(',').to_f
      end
    else
      atts[value[:site_id].to_s][:usg_funding] = 0.0
    end
    if atts[value[:site_id].to_s][:private_funding]
      if atts[value[:site_id].to_s][:private_funding].is_a?(String)
        atts[value[:site_id].to_s][:private_funding] = atts[value[:site_id].to_s][:private_funding].delete(',').to_f
      end
    else
      atts[value[:site_id].to_s][:private_funding] = 0.0
    end
    if atts[value[:site_id].to_s][:other_funding]
      if atts[value[:site_id].to_s][:other_funding].is_a?(String)
        atts[value[:site_id].to_s][:other_funding] = atts[value[:site_id].to_s][:other_funding].delete(',').to_f
      end
    else
      atts[value[:site_id].to_s][:other_funding] = 0.0
    end

    update_attribute(:site_specific_information, atts)
  end

  def national_staff=(ammount)
    if ammount.blank?
      write_attribute(:national_staff, 0)
    else
      case ammount
        when String then write_attribute(:national_staff, ammount.delete(',').to_f)
        else             write_attribute(:national_staff, ammount)
      end
    end
  end

  def donors_count
    @donors_count ||= donations.map{ |d| d.donor_id }.uniq.size
  end

  def resources_for_site(site)
    resources.select{ |r| r.sites_ids.include?(site.id.to_s) }
  end

  # Array of arrays
  # [[cluster, count], [cluster, count]]
  def projects_clusters_sectors(site, location_id = nil)
    if location_id.present?
      if site.navigate_by_country
        location_join = "inner join countries_projects cp on cp.project_id = p.id and cp.country_id = #{location_id.first}"
      else
        location_join = "inner join projects_regions as pr on pr.project_id = p.id and pr.region_id = #{location_id.last}"
      end
    end

    if site.navigate_by_cluster?
      sql="select c.id,c.name,count(ps.*) as count from clusters as c
      inner join clusters_projects as cp on c.id=cp.cluster_id
      inner join projects as p on p.id=cp.project_id and (p.end_date is null OR p.end_date > now())
      inner join projects_sites as ps on p.id=ps.project_id and ps.site_id=#{site.id}
      #{location_join}
      where p.primary_organization_id=#{self.id}
      group by c.id,c.name order by count DESC"
      Cluster.find_by_sql(sql).map do |c|
        [c,c.count.to_i]
      end
    else
      sql="select s.id,s.name,count(ps.*) as count from sectors as s
      inner join projects_sectors as pjs on s.id=pjs.sector_id
      inner join projects as p on p.id=pjs.project_id and (p.end_date is null OR p.end_date > now())
      inner join projects_sites as ps on p.id=ps.project_id and ps.site_id=#{site.id}
      #{location_join}
      where p.primary_organization_id=#{self.id}
      group by s.id,s.name order by count DESC"
      Sector.find_by_sql(sql).map do |s|
        [s,s.count.to_i]
      end
    end
  end

  def projects_clusters_sectors_for_donors(site, location_id = nil)
    if location_id.present?
      if site.navigate_by_country
        location_join = "inner join countries_projects cp on cp.project_id = p.id and cp.country_id = #{location_id.first}"
      else
        location_join = "inner join projects_regions as pr on pr.project_id = p.id and pr.region_id = #{location_id.last}"
      end
    end

    if site.navigate_by_cluster?
      sql="select c.id,c.name,count(ps.*) as count from clusters as c
      inner join clusters_projects as cp on c.id=cp.cluster_id
      inner join projects as p on p.id=cp.project_id and (p.end_date is null OR p.end_date > now())
      inner join projects_sites as ps on p.id=ps.project_id and ps.site_id=#{site.id}
      #{location_join}
      group by c.id,c.name order by count DESC"
      Cluster.find_by_sql(sql).map do |c|
        [c,c.count.to_i]
      end
    else
      sql="select s.id,s.name,count(ps.*) as count from sectors as s
      inner join projects_sectors as pjs on s.id=pjs.sector_id
      inner join projects as p on p.id=pjs.project_id and (p.end_date is null OR p.end_date > now())
      inner join projects_sites as ps on p.id=ps.project_id and ps.site_id=#{site.id}
      #{location_join}
      group by s.id,s.name order by count DESC"
      Sector.find_by_sql(sql).map do |s|
        [s,s.count.to_i]
      end
    end
  end

  # Array of arrays
  # [[region, count], [region, count]]
  def projects_regions(site, category_id = nil)
    if category_id.present? && category_id.to_i > 0
      if site.navigate_by_cluster?
        category_join = "inner join clusters_projects as cp on cp.project_id = p.id and cp.cluster_id = #{category_id}"
      else
        category_join = "inner join projects_sectors as pse on pse.project_id = p.id and pse.sector_id = #{category_id}"
      end
    end

    Region.find_by_sql(
<<-SQL
select r.id,r.name,r.level,r.parent_region_id, r.path, r.country_id,count(ps.*) as count from regions as r
  inner join projects_regions as pr on r.id=pr.region_id
  inner join projects as p on p.id=pr.project_id and (p.end_date is null OR p.end_date > now())
  inner join projects_sites as ps on p.id=ps.project_id and ps.site_id=#{site.id}
  #{category_join}
  where p.primary_organization_id=#{self.id}
        and r.level=#{site.level_for_region}
  group by r.id,r.name,r.level,r.parent_region_id, r.path, r.country_id order by count DESC
SQL
    ).map do |r|
      [r, r.count.to_i]
    end
  end

  def projects_regions_for_donors(site, category_id = nil, organization_id = nil, location_id = nil)
    if category_id.present? && category_id.to_i > 0
      if site.navigate_by_cluster?
        category_join = "inner join clusters_projects as cp on cp.project_id = p.id and cp.cluster_id = #{category_id}"
      else
        category_join = "inner join projects_sectors as pse on pse.project_id = p.id and pse.sector_id = #{category_id}"
      end
    end

    if organization_id.present? && organization_id.to_i > 0
      organization_filter = "and p.primary_organization_id = #{organization_id}"
    end

    if location_id.present?
      location_filter = "and r.id IN (#{location_id})"
    end

    Region.find_by_sql(
<<-SQL
select r.id,r.name,r.level,r.parent_region_id, r.path, r.country_id,count(ps.*) as count from regions as r
  inner join projects_regions as pr on r.id=pr.region_id #{location_filter}
  inner join projects as p on p.id=pr.project_id and (p.end_date is null OR p.end_date > now()) #{organization_filter}
  inner join projects_sites as ps on p.id=ps.project_id and ps.site_id=#{site.id}
  inner join donations as dn on dn.project_id = p.id
  #{category_join}
  where dn.donor_id = #{self.id}
        and r.level=#{site.level_for_region}
  group by r.id,r.name,r.level,r.parent_region_id, r.path, r.country_id order by count DESC
SQL
    ).map do |r|
      [r, r.count.to_i]
    end
  end

  # Array of arrays
  # [[country, count], [country, count]]
  def projects_countries(site, category_id = nil)
    if category_id.present? && category_id.to_i > 0
      if site.navigate_by_cluster?
        category_join = "inner join clusters_projects as cp on cp.project_id = p.id and cp.cluster_id = #{category_id}"
      else
        category_join = "inner join projects_sectors as pse on pse.project_id = p.id and pse.sector_id = #{category_id}"
      end
    end

    Country.find_by_sql(
<<-SQL
select c.id,c.name,count(ps.*) as count from countries as c
  inner join countries_projects as pr on c.id=pr.country_id
  inner join projects as p on p.id=pr.project_id and (p.end_date is null OR p.end_date > now())
  inner join projects_sites as ps on p.id=ps.project_id and ps.site_id=#{site.id}
  #{category_join}
  where p.primary_organization_id=#{self.id}
  group by c.id, c.name order by count DESC
SQL
    ).map do |r|
      [r, r.count.to_i]
    end
  end

  def donated_projects_count(site, options = nil)
    if options[:organization_id]
      sql = "select count(distinct(d.project_id)) from donations d
      inner join projects as p on d.project_id = p.id and (p.end_date is null OR p.end_date > now())
      inner join projects_sites as ps on d.project_id=ps.project_id and ps.site_id=#{site.id}
      where d.donor_id=#{self.id} and p.primary_organization_id=#{options[:organization_id]}"
    else
      sql = "select count(distinct(d.project_id)) from donations d
      inner join projects as p on d.project_id = p.id and (p.end_date is null OR p.end_date > now())
      inner join projects_sites as ps on d.project_id=ps.project_id and ps.site_id=#{site.id}
      where d.donor_id=#{self.id}"
    end
    ActiveRecord::Base.connection.execute(sql).first['count'].to_i
  end

  def projects_countries_for_donors(site, category_id = nil, organization_id = nil, location_id = nil)
    if category_id.present? && category_id.to_i > 0
      if site.navigate_by_cluster?
        category_join = "inner join clusters_projects as cp on cp.project_id = p.id and cp.cluster_id = #{category_id}"
      else
        category_join = "inner join projects_sectors as pse on pse.project_id = p.id and pse.sector_id = #{category_id}"
      end
    end

    if organization_id.present? && organization_id.to_i > 0
      organization_filter = "and p.primary_organization_id = #{organization_id}"
    end

    if location_id.present?
      location_filter = "and c.id IN (#{location_id})"
    end

    Country.find_by_sql(
<<-SQL
select c.id,c.name,count(ps.*) as count from countries as c
  inner join countries_projects as pr on c.id=pr.country_id #{location_filter}
  inner join projects as p on p.id=pr.project_id and (p.end_date is null OR p.end_date > now()) #{organization_filter}
  inner join projects_sites as ps on p.id=ps.project_id and ps.site_id=#{site.id}
  inner join donations as dn on dn.project_id = p.id
  #{category_join}
  where dn.donor_id = #{self.id}
  group by c.id, c.name order by count DESC
SQL
    ).map do |r|
      [r, r.count.to_i]
    end
  end

  def budget(site = nil)
    if site
      atts_for_site = attributes_for_site(site)
      return (atts_for_site[:usg_funding].to_f || 0) + (atts_for_site[:private_funding].to_f || 0) + (atts_for_site[:other_funding].to_f || 0)
    else
      self[:budget]
    end
  end

  # to get only id and name
  def self.get_select_values
    scoped.select("id,name").order("name ASC")
  end

  def self.with_admin_user
    select('DISTINCT organizations.id, organizations.name').
    joins(:user).
    where('users.organization_id IS NOT NULL').
    order('name asc')
  end

  def projects_count(site, category_id = nil, location_id = nil)

    if category_id.present? && category_id.to_i > 0
      if site.navigate_by_cluster?
        category_join = "inner join clusters_projects as cp on cp.project_id = p.id and cp.cluster_id = #{category_id}"
      else
        category_join = "inner join projects_sectors as pse on pse.project_id = p.id and pse.sector_id = #{category_id}"
      end
    end

    if location_id.present?
      if location_id.size == 1
        location_join = "inner join countries_projects cp on cp.project_id = p.id and cp.country_id = #{location_id.first}"
      else
        location_join = "inner join projects_regions as pr on pr.project_id = p.id and pr.region_id = #{location_id.last}"
      end
    end

    sql = "select count(p.id) as count from projects as p
    inner join projects_sites as ps on p.id=ps.project_id and ps.site_id=#{site.id}
    #{category_join}
    #{location_join}
    where p.primary_organization_id=#{self.id} and (p.end_date is null OR p.end_date > now())"
    ActiveRecord::Base.connection.execute(sql).first['count'].to_i
  end

  def projects_for_kml(site)
    sql = "select p.name, ST_AsKML(p.the_geom) as the_geom
    from projects as p
    inner join projects_sites as ps on p.id=ps.project_id and ps.site_id=#{site.id}
    where p.primary_organization_id=#{self.id} and (p.end_date is null OR p.end_date > now())"
    ActiveRecord::Base.connection.execute(sql)
  end


  def total_regions(site)
    sql = "select count(distinct(pr.region_id)) as count from projects_regions as pr
    inner join regions as r on pr.region_id=r.id and level=#{site.level_for_region}
    inner join projects as p on p.id=pr.project_id and (p.end_date is null OR p.end_date > now())
                                and p.primary_organization_id=#{self.id}
    inner join projects_sites as psi on p.id=psi.project_id and psi.site_id=#{site.id}"
    ActiveRecord::Base.connection.execute(sql).first['count'].to_i
  end

  def total_countries(site)
    sql = "select count(distinct(pr.country_id)) as count from countries_projects as pr
    inner join projects as p on p.id=pr.project_id and (p.end_date is null OR p.end_date > now())
                                and p.primary_organization_id=#{self.id}
    inner join projects_sites as psi on p.id=psi.project_id and psi.site_id=#{site.id}"
    ActiveRecord::Base.connection.execute(sql).first['count'].to_i
  end

  def sites
    Site.for_organization(self)
  end

  def check_user_valid
    self.attributes = attributes.reject
  end


  def update_data_denormalization
    sql = """UPDATE data_denormalization
            SET organization_name = '#{self.name}'
            WHERE organization_id = #{self.id}"""
    ActiveRecord::Base.connection.execute(sql)
  end

  def get_profile
    profile = {}
    profile[:name] = self.name
    profile[:details] = {'name' => self.name, 'description' => self.description, 'contact_info' => {'contact_name' => self.contact_name, 'contact_position' => self.contact_position, 'email' => self.contact_email, 'phone' => self.contact_phone_number}, 'donation_info' => {'donation_address' => self.donation_address, 'donation_website' => self.donation_website} }
    profile[:countries] = Country.joins([:projects => :primary_organization]).where('organizations.id = ?', self.id).select(['countries.name','count(projects.id)']).group('countries.name')
    profile[:donors] = Organization.joins(:donations_made => :project).where('projects.primary_organization_id = ?', self.id).select(['organizations.name','count(projects.id)']).group('organizations.name')
    profile[:sectors] = Sector.joins([:projects => :primary_organization]).where('organizations.id = ?', self.id).select(['sectors.name','count(projects.id)']).group('sectors.name')
    profile[:projects] = self.projects.select([:id, :name, :budget, :start_date, :end_date, :the_geom])
    profile
  end

  def get_profile_for_donor
    profile = {}
    profile[:name] = self.name
    profile[:projects] = self.donations_made.map{|d| {:project => {'the_geom' => d.project.the_geom, 'id' => d.project.id, 'name' => d.project.name, 'budget' => d.project.budget, 'start_date' => d.project.start_date, 'end_date' => d.project.end_date}} }
    profile[:organizations] = Organization.joins(:projects => :donations).where(:donations => {:donor_id => self.id}).select(['organizations.name','count(projects.id)']).group('organizations.name')
    profile[:sectors] = Sector.joins(:projects => :donations).where(:donations => {:donor_id => self.id}).select(['sectors.name','count(projects.id)']).group('sectors.name')
    profile[:countries] = Country.joins(:projects => :donations).where(:donations => {:donor_id => self.id}).select(['countries.name','count(projects.id)']).group('countries.name')

    profile
  end

  # IATI

  def self.types
    ["Government", "Other Public Sector", "International NGO", "National NGO", "Regional NGO", "Public Private Partnership", "Multilateral", "Foundation ", "Private Sector", "Academic, Training and Research"]
  end
  def self.type_codes
    [10, 15, 21, 22, 23, 30, 40, 60, 70, 80]
  end

  def set_org_type_code
    self.organization_type_code = Organization.type_codes[Organization.types.index(self.organization_type)] if self.organization_type.present?
  end

  def set_budget_usd
    if budget_field_changed? && budget? && budget_currency?
      if budget_currency == "USD"
        self.budget_usd = self[:budget]
      else
        if budget_fiscal_year?
          self.budget_usd = budget_coverted_to_usd
        end
      end
    end
  end

  def budget_field_changed?
    budget_changed? || budget_currency_changed? || budget_fiscal_year_changed?
  end

  def budget_coverted_to_usd
    conversion = FixerIo.new(budget_fiscal_year, budget_currency, "USD").rate
    if conversion.present?
      budget.to_d * conversion.to_d
    end
  rescue
    nil
  end

  def projects_sectors_or_clusters(site, location_id = nil, organization_id = nil, is_region = false)
    if location_id.present?
      if site.navigate_by_country && !is_region
      #if site.navigate_by_country
        location_join = "inner join countries_projects cp on cp.project_id = p.id and cp.country_id = #{location_id.first}"
      else
        location_join = "inner join projects_regions as pr on pr.project_id = p.id and pr.region_id = #{location_id.last}"
      end
    end

    if organization_id.present? && organization_id > 0
      organization_condition = "and p.primary_organization_id=#{organization_id}"
    end

    if site.navigate_by_sector?
      sql="select s.id,s.name,count(ps.*) as count from sectors as s
      inner join projects_sectors as ps on s.id=ps.sector_id
      inner join projects_sites as psi on ps.project_id=psi.project_id and psi.site_id=#{site.id}
      inner join projects as p on ps.project_id=p.id and (p.end_date is null OR p.end_date > now()) #{organization_condition}
      inner join donations as d on psi.project_id=d.project_id and d.donor_id=#{self.id}
      #{location_join}
      group by s.id,s.name order by count DESC"
      Sector.find_by_sql(sql).map do |s|
        [s,s.count.to_i]
      end
    else
      sql="select c.id,c.name,count(ps.*) as count from clusters as c
      inner join clusters_projects as cp on c.id=cp.cluster_id
      inner join projects_sites as ps on cp.project_id=ps.project_id and ps.site_id=#{site.id}
      inner join projects as p on ps.project_id=p.id and (p.end_date is null OR p.end_date > now()) #{organization_condition}
      inner join donations as d on ps.project_id=d.project_id and d.donor_id=#{self.id}
      #{location_join}
      group by c.id,c.name order by count DESC"
      Cluster.find_by_sql(sql).map do |c|
        [c,c.count.to_i]
      end
    end
  end

end
