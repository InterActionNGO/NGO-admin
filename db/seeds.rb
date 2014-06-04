# Mandatory seeds

User.first_or_create :email => 'admin@example.com', :password => 'admin', :password_confirmation => 'admin'



settings = Settings.find_or_create_by_id(1)
data = HashWithIndifferentAccess.new
data[:main_site_host] = 'ngoaidmap.org'
settings.data = data
settings.save!


Theme.first_or_create :name => 'Garnet',
             :css_file => '/stylesheets/themes/garnet.css',
             :thumbnail_path => '/images/themes/1/thumbnail.png',
             :data => {
               :overview_map_chco => "F7F7F7,8BC856,336600",
               :overview_map_chf => "bg,s,2F84A3",
               :overview_map_marker_source => "/images/themes/1/",
               :georegion_map_chco => "F7F7F7,8BC856,336600",
               :georegion_map_chf => "bg,s,2F84A3",
               :georegion_map_marker_source => "/images/themes/1/",
               :georegion_map_stroke_color => "#000000",
               :georegion_map_fill_color => "#000000"
             }

Theme.first_or_create :name => 'Pink',
             :css_file => '/stylesheets/themes/pink.css',
             :thumbnail_path => '/images/themes/2/thumbnail.png',
             :data => {
               :overview_map_chco => "F7F7F7,8BC856,336600",
               :overview_map_chf => "bg,s,2F84A3",
               :overview_map_marker_source => "/images/themes/2/",
               :georegion_map_chco => "F7F7F7,8BC856,336600",
               :georegion_map_chf => "bg,s,2F84A3",
               :georegion_map_marker_source => "/images/themes/2/",
               :georegion_map_stroke_color => "#000000",
               :georegion_map_fill_color => "#000000"
             }

Theme.first_or_create :name => 'Blue',
             :css_file => '/stylesheets/themes/blue.css',
             :thumbnail_path => '/images/themes/3/thumbnail.png',
             :data => {
               :overview_map_chco => "F7F7F7,8BC856,336600",
               :overview_map_chf => "bg,s,2F84A3",
               :overview_map_marker_source => "/images/themes/3/",
               :georegion_map_chco => "F7F7F7,8BC856,336600",
               :georegion_map_chf => "bg,s,2F84A3",
               :georegion_map_marker_source => "/images/themes/3/",
               :georegion_map_stroke_color => "#000000",
               :georegion_map_fill_color => "#000000"
             }

# Env seeds (development)

Cluster.first_or_create :name => 'Camp Coordination and Management'
Cluster.first_or_create :name => 'Early Recovery'
Cluster.first_or_create :name => 'Education'
Cluster.first_or_create :name => 'Emergency Telecommunications'
Cluster.first_or_create :name => 'Food Security and Agriculture'
Cluster.first_or_create :name => 'Health'
Cluster.first_or_create :name => 'Logistics'
Cluster.first_or_create :name => 'Nutrition'
Cluster.first_or_create :name => 'Protection'
Cluster.first_or_create :name => 'Shelter and Non-Food Items'
Cluster.first_or_create :name => 'Water Sanitation and Hygiene'

Sector.first_or_create :name => 'Agriculture'
Sector.first_or_create :name => 'Communications'
Sector.first_or_create :name => 'Disaster Management'
Sector.first_or_create :name => 'Economic Recovery and Development'
Sector.first_or_create :name => 'Education'
Sector.first_or_create :name => 'Environment'
Sector.first_or_create :name => 'Food Aid'
Sector.first_or_create :name => 'Health'
Sector.first_or_create :name => 'Human Rights Democracy and Governance'
Sector.first_or_create :name => 'Peace and Security'
Sector.first_or_create :name => 'Protection'
Sector.first_or_create :name => 'Shelter and Housing'
Sector.first_or_create :name => 'Water Sanitation and Hygiene'
Sector.first_or_create :name => 'Other'

Tag.first_or_create :name => 'asia'
Tag.first_or_create :name => 'africa'
Tag.first_or_create :name => 'childhood'
Tag.first_or_create :name => 'earthquake'

##


####################################################################
#
# HAITI SITE
#
####################################################################

#  sites for testing purposes. Add this line to your /etc/hosts:
#  127.0.0.1       haiti.ngoaidmap.org
site = Site.find_or_initialize_by_name('Haiti Aid Map')

site.update_attributes(
  :name              => 'Haiti Aid Map',
  :url               => 'haiti.ngoaidmap.org',
  :status            => true,
  :project_classification => 1,
  :short_description =>'Mapping efforts to reduce poverty and suffering',
  :long_description  =>'On January 12th 2010, a catastrophic earthquake occured at Haiti, leaving more than 250.000 deaths and more than 1.000.000 homeless people. It was one of the biggest disasters in the century. Since then and until now, a huge effort has been made by some of the interaction members',
  :theme             => Theme.find_by_name('Garnet'),
  :aid_map_image     => File.open(File.join(Rails.root, '/public/images/sites/haiti_img_example.jpg')),
  :navigate_by_level3 => true,
  :google_analytics_id => 'UA-20618946-2',
  :word_for_regions  => "Communes"
)

haiti_site_id = Site.find_by_name('Haiti Aid Map').id


##############################
# Generate pages
##############################

if (1==0)
  # ===> ABOUT PARENT PAGE
  haiti_about_page = Page.find_or_initialize_by_title_and_site_id('About', haiti_site_id)

  haiti_about_page.update(
    :title        => 'About',
    :body         => '',
    :site_id      => haiti_site_id,
    :permalink    => '',
    :published    => true,
    :parent_id    => nil,
    :order_index  => 0
  )

  haiti_about_page_id = haiti_about_page.id

  haiti_child_page = Page.find_or_initialize_by_title_and_site_id_and_parent_id('A-child-page', haiti_site_id, haiti_about_page_id)

  haiti_child_page.update(
    :title        => 'A-child-page',
    :body         => '',
    :site_id      => haiti_site_id,
    :permalink    => '',
    :published    => true,
    :parent_id    => nil,
    :order_index  => 0
  )

  # ===> DATA PARENT PAGE
  page = Page.find_or_initialize_by_title_and_site_id('Data', haiti_site_id)

  page.update(
    :title        => 'Data',
    :body         => '',
    :site_id      => haiti_site_id,
    :permalink    => '',
    :published    => true,
    :parent_id    => nil,
    :order_index  => 0
  )
  data_page_id = page.id
end


####################################################################
#
# FOOD AND SECURITY SITE
#
####################################################################

if (1==0)
  site = Site.find_or_initialize_by_name('Food Security')

  site.update_attributes(
    :name => 'Food Security',
    :url => "#{Rails.env.eql?('development') ? 'dev-' : ''}food.ngoaidmap.org",
    :status => true,
    :project_classification => 1,
    :short_description => 'Food security refers to the availability of food and one’s access to it',
    :long_description => 'The Special Programme for Food Security (SPFS) helps governments replicate successful food security practices on a national scale. The SPFS also encourages investment in rural infrastructure, off-farm income generation, urban agriculture and safety nets',
    :theme => Theme.find_by_name('Garnet'),
    :aid_map_image => File.open(File.join(Rails.root, '/public/images/sites/food_img_example.jpg')),
    :navigate_by_country => true,
    :navigate_by_level1 => true
    :word_for_regions => "Country"
  )
end


site = Site.find_or_initialize_by_name('global')

site.update_attributes(
  :name => 'global',
  :url => "global.ngoaidmap.org",
  :status => true,
  :project_classification => 1,
  :short_description => 'Global site to unify all projects',
  :long_description => 'Global site to unify all projects',
  :theme => Theme.find_by_name('Garnet'),
  :aid_map_image => File.open(File.join(Rails.root, '/public/images/sites/food_img_example.jpg')),
  :navigate_by_country => true,
  :navigate_by_level1 => true
  :word_for_regions => "Country"
)





####################################################################
#
# SECTORS
#
####################################################################

