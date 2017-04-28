# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20170424151703) do

  create_table "changes_history_records", :force => true do |t|
    t.integer  "user_id"
    t.datetime "when"
    t.text     "how"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "what_id"
    t.string   "what_type"
    t.boolean  "reviewed",         :default => false
    t.string   "who_email"
    t.string   "who_organization"
  end

  create_table "changes_history_records_copy", :id => false, :force => true do |t|
    t.integer  "id",               :null => false
    t.integer  "user_id"
    t.datetime "when"
    t.text     "how"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "what_id"
    t.string   "what_type"
    t.boolean  "reviewed"
    t.string   "who_email"
    t.string   "who_organization"
  end

  create_table "clusters", :force => true do |t|
    t.string "name"
  end

  create_table "clusters_projects", :id => false, :force => true do |t|
    t.integer "cluster_id"
    t.integer "project_id"
  end

  create_table "countries", :force => true do |t|
    t.string  "name"
    t.string  "code"
    t.spatial "the_geom",         :limit => {:type=>"multi_polygon", :srid=>4326}
    t.string  "wiki_url"
    t.text    "wiki_description"
    t.string  "iso2_code"
    t.string  "iso3_code"
    t.float   "center_lat"
    t.float   "center_lon"
    t.text    "the_geom_geojson"
  end

  create_table "countries_projects", :id => false, :force => true do |t|
    t.integer "country_id", :null => false
    t.integer "project_id", :null => false
  end

  create_table "data_denormalization", :id => false, :force => true do |t|
    t.integer  "project_id"
    t.string   "project_name",        :limit => 2000
    t.text     "project_description"
    t.integer  "organization_id"
    t.string   "organization_name",   :limit => 2000
    t.date     "end_date"
    t.text     "regions"
    t.string   "regions_ids",         :limit => nil
    t.text     "countries"
    t.string   "countries_ids",       :limit => nil
    t.text     "sectors"
    t.string   "sector_ids",          :limit => nil
    t.text     "clusters"
    t.string   "cluster_ids",         :limit => nil
    t.string   "donors_ids",          :limit => nil
    t.boolean  "is_active"
    t.integer  "site_id"
    t.datetime "created_at"
    t.date     "start_date"
  end

  create_table "data_export", :id => false, :force => true do |t|
    t.integer "project_id"
    t.string  "project_name",                            :limit => 2000
    t.text    "project_description"
    t.integer "organization_id"
    t.string  "organization_name",                       :limit => 2000
    t.text    "implementing_organization"
    t.text    "partner_organizations"
    t.text    "cross_cutting_issues"
    t.date    "start_date"
    t.date    "end_date"
    t.float   "budget"
    t.text    "target"
    t.integer "estimated_people_reached",                :limit => 8
    t.string  "project_contact_person"
    t.string  "project_contact_email"
    t.string  "project_contact_phone_number"
    t.text    "activities"
    t.string  "intervention_id"
    t.text    "additional_information"
    t.string  "awardee_type"
    t.date    "date_provided"
    t.date    "date_updated"
    t.string  "project_contact_position"
    t.string  "project_website"
    t.text    "verbatim_location"
    t.text    "calculation_of_number_of_people_reached"
    t.text    "project_needs"
    t.text    "sectors"
    t.text    "clusters"
    t.text    "project_tags"
    t.text    "countries"
    t.text    "regions_level1"
    t.text    "regions_level2"
    t.text    "regions_level3"
  end

  create_table "donations", :force => true do |t|
    t.integer "donor_id"
    t.integer "project_id"
    t.float   "amount"
    t.date    "date"
    t.integer "office_id"
  end

  create_table "geolocations", :id => false, :force => true do |t|
    t.integer  "id",                                                       :null => false
    t.string   "uid",               :limit => nil
    t.string   "name",              :limit => nil
    t.float    "latitude"
    t.float    "longitude"
    t.string   "fclass",            :limit => nil
    t.string   "fcode",             :limit => nil
    t.string   "country_code",      :limit => nil
    t.string   "country_name",      :limit => nil
    t.string   "country_uid",       :limit => nil
    t.string   "cc2",               :limit => nil
    t.string   "admin1",            :limit => nil
    t.string   "admin2",            :limit => nil
    t.string   "admin3",            :limit => nil
    t.string   "admin4",            :limit => nil
    t.string   "provider",          :limit => nil, :default => "Geonames"
    t.integer  "adm_level"
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
    t.string   "g0",                :limit => nil
    t.string   "g1",                :limit => nil
    t.string   "g2",                :limit => nil
    t.string   "g3",                :limit => nil
    t.string   "g4",                :limit => nil
    t.string   "custom_geo_source", :limit => nil
  end

  create_table "geolocations_projects", :id => false, :force => true do |t|
    t.integer "geolocation_id"
    t.integer "project_id"
  end

  create_table "layer_styles", :force => true do |t|
    t.string "title"
    t.string "name"
  end

  create_table "layers", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.text     "credits"
    t.datetime "date"
    t.float    "min"
    t.float    "max"
    t.string   "units"
    t.boolean  "status"
    t.string   "cartodb_table"
    t.text     "sql"
    t.string   "long_title"
  end

  create_table "media_resources", :force => true do |t|
    t.integer  "position",                                :default => 0
    t.integer  "element_id"
    t.integer  "element_type"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_filesize"
    t.datetime "picture_updated_at"
    t.string   "video_url"
    t.text     "video_embed_html"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "caption"
    t.string   "video_thumb_file_name"
    t.string   "video_thumb_content_type"
    t.integer  "video_thumb_file_size"
    t.datetime "video_thumb_updated_at"
    t.string   "external_image_url",       :limit => nil
  end

  create_table "offices", :force => true do |t|
    t.integer  "organization_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.float    "budget"
    t.string   "website"
    t.string   "twitter"
    t.string   "facebook"
    t.string   "hq_address"
    t.string   "contact_email"
    t.string   "contact_phone_number"
    t.string   "donation_address"
    t.string   "zip_code"
    t.string   "city"
    t.string   "state"
    t.string   "donation_phone_number"
    t.string   "donation_website"
    t.text     "site_specific_information"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "contact_name"
    t.string   "contact_position"
    t.string   "contact_zip"
    t.string   "contact_city"
    t.string   "contact_state"
    t.string   "contact_country"
    t.string   "donation_country"
    t.string   "media_contact_name"
    t.string   "media_contact_position"
    t.string   "media_contact_phone_number"
    t.string   "media_contact_email"
    t.string   "main_data_contact_name"
    t.string   "main_data_contact_position"
    t.string   "main_data_contact_phone_number"
    t.string   "main_data_contact_email"
    t.string   "main_data_contact_zip"
    t.string   "main_data_contact_city"
    t.string   "main_data_contact_state"
    t.string   "main_data_contact_country"
    t.string   "organization_id"
    t.string   "organization_type"
    t.integer  "organization_type_code"
    t.string   "iati_organizationid"
    t.boolean  "publishing_to_iati",                                                           :default => false
    t.string   "membership_status",                                                            :default => "Non Member"
    t.integer  "old_donor_id"
    t.boolean  "international"
    t.string   "acronym",                        :limit => nil
    t.date     "membership_add_date"
    t.date     "membership_drop_date"
    t.string   "budget_currency",                :limit => nil
    t.decimal  "budget_usd",                                    :precision => 13, :scale => 2
    t.date     "budget_fiscal_year"
    t.string   "hq_address2",                    :limit => nil
    t.string   "donation_address2",              :limit => nil
  end

  create_table "organizations2", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.float    "budget"
    t.string   "website"
    t.integer  "national_staff"
    t.string   "twitter"
    t.string   "facebook"
    t.string   "hq_address"
    t.string   "contact_email"
    t.string   "contact_phone_number"
    t.string   "donation_address"
    t.string   "zip_code"
    t.string   "city"
    t.string   "state"
    t.string   "donation_phone_number"
    t.string   "donation_website"
    t.text     "site_specific_information"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "international_staff"
    t.string   "contact_name"
    t.string   "contact_position"
    t.string   "contact_zip"
    t.string   "contact_city"
    t.string   "contact_state"
    t.string   "contact_country"
    t.string   "donation_country"
    t.integer  "estimated_people_reached"
    t.float    "private_funding"
    t.float    "usg_funding"
    t.float    "other_funding"
    t.float    "private_funding_spent"
    t.float    "usg_funding_spent"
    t.float    "other_funding_spent"
    t.float    "spent_funding_on_relief"
    t.float    "spent_funding_on_reconstruction"
    t.integer  "percen_relief"
    t.integer  "percen_reconstruction"
    t.string   "media_contact_name"
    t.string   "media_contact_position"
    t.string   "media_contact_phone_number"
    t.string   "media_contact_email"
  end

  create_table "organizations_projects", :id => false, :force => true do |t|
    t.integer "organization_id"
    t.integer "project_id"
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "site_id"
    t.boolean  "published"
    t.string   "permalink"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.integer  "order_index"
  end

  create_table "partners", :force => true do |t|
    t.integer  "site_id"
    t.string   "name"
    t.string   "url"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "label"
  end

  create_table "partnerships", :force => true do |t|
    t.integer  "partner_id", :null => false
    t.integer  "project_id", :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "projects", :force => true do |t|
    t.string   "name",                                    :limit => 2000
    t.text     "description"
    t.integer  "primary_organization_id"
    t.text     "implementing_organization"
    t.text     "partner_organizations"
    t.text     "cross_cutting_issues"
    t.date     "start_date"
    t.date     "end_date"
    t.float    "budget"
    t.text     "target"
    t.integer  "estimated_people_reached",                :limit => 8
    t.string   "contact_person"
    t.string   "contact_email"
    t.string   "contact_phone_number"
    t.text     "site_specific_information"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.spatial  "the_geom",                                :limit => {:type=>"geometry", :srid=>4326}
    t.text     "activities"
    t.string   "intervention_id"
    t.text     "additional_information"
    t.string   "awardee_type"
    t.date     "date_provided"
    t.date     "date_updated"
    t.string   "contact_position"
    t.string   "website"
    t.text     "verbatim_location"
    t.text     "calculation_of_number_of_people_reached"
    t.text     "project_needs"
    t.text     "idprefugee_camp"
    t.string   "organization_id"
    t.string   "budget_currency",                                                                                                    :default => "USD"
    t.date     "budget_value_date"
    t.float    "target_project_reach"
    t.float    "actual_project_reach"
    t.string   "project_reach_unit",                                                                                                 :default => "individuals"
    t.integer  "prime_awardee_id"
    t.string   "geographical_scope",                                                                                                 :default => "regional"
    t.decimal  "budget_usd",                                                                          :precision => 13, :scale => 2
  end

  create_table "projects_regions", :id => false, :force => true do |t|
    t.integer "region_id"
    t.integer "project_id"
  end

  create_table "projects_sectors", :id => false, :force => true do |t|
    t.integer "sector_id"
    t.integer "project_id"
  end

  create_table "projects_sites", :id => false, :force => true do |t|
    t.integer "project_id"
    t.integer "site_id"
  end

  create_table "projects_synchronizations", :force => true do |t|
    t.text     "projects_file_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects_tags", :id => false, :force => true do |t|
    t.integer "tag_id"
    t.integer "project_id"
  end

  create_table "regions", :force => true do |t|
    t.string  "name"
    t.integer "level"
    t.integer "country_id"
    t.integer "parent_region_id"
    t.spatial "the_geom",         :limit => {:type=>"geometry", :srid=>4326}
    t.integer "gadm_id"
    t.string  "wiki_url"
    t.text    "wiki_description"
    t.string  "code"
    t.float   "center_lat"
    t.float   "center_lon"
    t.text    "the_geom_geojson"
    t.text    "ia_name"
    t.string  "path"
  end

  create_table "resources", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.integer  "element_id"
    t.integer  "element_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "site_specific_information"
  end

  create_table "sectors", :force => true do |t|
    t.string   "name"
    t.string   "oecd_dac_name"
    t.string   "oecd_dac_purpose_code"
    t.string   "sector_vocab_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", :force => true do |t|
    t.text "data"
  end

  create_table "site_layers", :id => false, :force => true do |t|
    t.integer "site_id"
    t.integer "layer_id"
    t.integer "layer_style_id"
  end

  create_table "sites", :force => true do |t|
    t.string   "name"
    t.text     "short_description"
    t.text     "long_description"
    t.string   "contact_email"
    t.string   "contact_person"
    t.string   "url"
    t.string   "permalink"
    t.string   "google_analytics_id"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.integer  "theme_id"
    t.string   "blog_url"
    t.string   "word_for_clusters"
    t.string   "word_for_regions"
    t.boolean  "show_global_donations_raises",                                                :default => false
    t.integer  "project_classification",                                                      :default => 0
    t.string   "geographic_context_country_id",   :limit => nil
    t.integer  "geographic_context_region_id"
    t.integer  "project_context_cluster_id"
    t.integer  "project_context_sector_id"
    t.integer  "project_context_organization_id"
    t.string   "project_context_tags"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.spatial  "geographic_context_geometry",     :limit => {:type=>"geometry", :srid=>4326}
    t.string   "project_context_tags_ids"
    t.boolean  "status",                                                                      :default => false
    t.float    "visits",                                                                      :default => 0.0
    t.float    "visits_last_week",                                                            :default => 0.0
    t.string   "aid_map_image_file_name"
    t.string   "aid_map_image_content_type"
    t.integer  "aid_map_image_file_size"
    t.datetime "aid_map_image_updated_at"
    t.boolean  "navigate_by_country",                                                         :default => false
    t.boolean  "navigate_by_level1",                                                          :default => false
    t.boolean  "navigate_by_level2",                                                          :default => false
    t.boolean  "navigate_by_level3",                                                          :default => false
    t.text     "map_styles"
    t.float    "overview_map_lat"
    t.float    "overview_map_lon"
    t.integer  "overview_map_zoom"
    t.text     "internal_description"
    t.boolean  "featured",                                                                    :default => false
  end

  create_table "sites_tags", :id => false, :force => true do |t|
    t.integer "site_id"
    t.integer "tag_id"
  end

  create_table "stats", :force => true do |t|
    t.integer "site_id"
    t.integer "visits"
    t.date    "date"
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.integer  "count",       :default => 0
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "themes", :force => true do |t|
    t.string "name"
    t.string "css_file"
    t.string "thumbnail_path"
    t.text   "data"
  end

  create_table "users", :force => true do |t|
    t.string   "name",                                   :limit => 100, :default => ""
    t.string   "email",                                  :limit => 100
    t.string   "crypted_password",                       :limit => 40
    t.string   "salt",                                   :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",                         :limit => 40
    t.datetime "remember_token_expires_at"
    t.integer  "organization_id"
    t.string   "role"
    t.boolean  "blocked",                                               :default => false
    t.string   "site_id"
    t.text     "description"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.datetime "last_login"
    t.boolean  "six_months_since_last_login_alert_sent",                :default => false
    t.integer  "login_fails",                                           :default => 0
  end

end
