class AddGenericSite < ActiveRecord::Migration
  def self.up
    Site.create(:name => "generic", :short_description => "generic", :long_description => "Global site", :contact_email => "alfonso@simbiotica.es", :contact_person => "Simbiótica dev team",
      :url => "generic.ngoaidmap.org", :google_analytics_id => "UA-XXXXXXXX-1", :theme_id => 1, :word_for_clusters => "", :word_for_regions => "", :show_global_donations_raises => false,
      :project_classification => 0, :project_context_tags => '', :status => false, :visits => 0, :visits_last_week => 0, :navigate_by_country => true, :navigate_by_level1 => true,
      :navigate_by_level2 => false, :navigate_by_level3 => false, :overview_map_lat => 41.1661201118013, :overview_map_lon => 2.87361145019530984, :overview_map_zoom => 1, :internal_description => "Global site for unification" )
  end

  def self.down
    Site.delete_all(name => "generic")
  end
end
