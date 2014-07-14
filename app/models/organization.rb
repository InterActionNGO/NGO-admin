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
  has_one :user

  accepts_nested_attributes_for :user, :reject_if => proc {|a| a['email'].blank?}, :allow_destroy => true

  before_save :check_user_valid

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

  def budget(site)
    atts_for_site = attributes_for_site(site)
    return (atts_for_site[:usg_funding].to_f || 0) + (atts_for_site[:private_funding].to_f || 0) + (atts_for_site[:other_funding].to_f || 0)
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

  def projects_for_csv(site)
    sql = "select p.id, p.name, p.description, p.primary_organization_id, p.implementing_organization, p.partner_organizations, p.cross_cutting_issues, p.start_date, p.end_date, p.budget, p.target, p.estimated_people_reached, p.contact_person, p.contact_email, p.contact_phone_number, p.site_specific_information, p.created_at, p.updated_at, p.activities, p.intervention_id, p.additional_information, p.awardee_type, p.date_provided, p.date_updated, p.contact_position, p.website, p.verbatim_location, p.calculation_of_number_of_people_reached, p.project_needs, p.idprefugee_camp
    from projects as p
    inner join projects_sites as ps on p.id=ps.project_id and ps.site_id=#{site.id}
    where p.primary_organization_id=#{self.id} and (p.end_date is null OR p.end_date > now())"
    ActiveRecord::Base.connection.execute(sql)
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

end
