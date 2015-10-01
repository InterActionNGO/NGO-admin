source 'http://rubygems.org'

ruby '1.8.7'

gem 'rails', '3.0.19'

# PostgreSQL
gem 'pg',                       '0.9.0'
gem 'nofxx-georuby', :require => 'geo_ruby'
gem 'spatial_adapter'
gem 'newrelic_rpm'
gem "will_paginate", "3.0.pre2"
gem 'sanitize', '2.0.3'
gem 'paperclip', '~> 2.7'
gem 'garb'
gem 'csv-mapper'
gem 'fastercsv'
gem 'money'
gem 'geokit'
gem 'nokogiri', '< 1.6.0'
gem 'memcache-client'
gem 'spreadsheet'
gem 'roadie'
gem 'ruby-oembed'
gem 'sass'
gem 'compass'
gem 'wkhtmltopdf-binary'
gem 'wicked_pdf'
gem 'rd_searchlogic', :require => 'searchlogic', :git => 'git://github.com/railsdog/searchlogic.git'

group :development do
  gem 'git-up'
  gem 'capistrano', :require => false
  gem 'rvm-capistrano'
  gem 'capistrano-ext'
  gem 'wirble'
  gem 'railroady'
  gem 'mail_view', :git => 'https://github.com/37signals/mail_view.git'
  gem 'puma'
end

group :test, :development do
  gem 'rr', :tag => 'v1.0.0'
  gem "rspec-rails"
  gem 'launchy'
  gem 'capybara', '~> 0.4.0'
  gem 'webrat'
  gem 'database_cleaner', :tag => 'v0.5.2'
  gem 'ruby-debug'
end
