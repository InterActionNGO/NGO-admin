require File.expand_path('../boot', __FILE__)

require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module Iom
  class Application < Rails::Application
    config.action_view.javascript_expansions[:defaults] = %w()

    config.encoding = "utf-8"

    config.filter_parameters += [:password]
  end
end


require 'authenticated_system'