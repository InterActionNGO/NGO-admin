require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env) if defined?(Bundler)

module Iom
  class Application < Rails::Application
    config.action_view.javascript_expansions[:defaults] = %w()

    Paperclip::Railtie.insert

    config.encoding = "utf-8"

    config.filter_parameters += [:password]

    config.autoload_paths += %W(#{Rails.root}/app/controllers/sweepers)

    config.iati_publisher = 'ia_nam'
    config.iati_api_key = ENV['IATI_API_KEY_IA_NAM']
    config.iati_name_prefix = 'ia_nam-o'
    config.iati_title_suffix = ' - Activities (NGO Aid Map)'
    config.iati_resource_baseurl = 'https://ngoaidmap.org/iati/organizations/'
    config.iati_dataset_notes = "Data is provided to NGO Aid Map by InterAction members on a voluntary basis, so this data may represent only a partial picture of this organization's activities."
    config.iati_owner_org_id = 'c3b62c3d-ffdf-403c-99eb-270f693cd9e8'
    config.iati_publisher_title = "InterAction's NGO Aid Map"
    config.iati_publisher_email = "mappinginfo@interaction.org"
    config.iati_standard_version = '2.02'
  end

  class InvalidOffset < Exception; end;
end

require 'open-uri'
require 'authenticated_system'
require 'acts_as_resource'
require 'will_paginate_random_collection'
require 'model_changes_recorder'
require 'video_provider'
require 'iati_registry'
