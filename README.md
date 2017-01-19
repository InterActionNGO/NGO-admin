== Welcome to NGOAIDMAP

NGOAIDMAP is a website available at http://ngoaidmap.org/. It was a custom development done initially by Vizzuality (vizzuality.com) for Interaction (interaction.org). The application consist of a database of projects. Those projects get aggregated to create Sites, for example http://foodsecurity.ngoaidmap.org/ or http://haiti.ngoaidmap.org/

It is probably a very specific application to be used directly, but the ideas and code behind it might be applicable for other people needs. If you have questions on how to use contact@vizzuality.com

== Database structure

NGOAIDMAP is a project that allows you to create websites about projects around a certain topic. For example haiti or foodsecurity.

The database consist of 4 main tables: "projects" done by "organizations" funded by "donors" which are included in different "sites".

Take a look at the database schema at db/db_schema.pdf to get a better idea of what the project does.

== Requirements

NGOAIDMAP is a Ruby on Rails application. The dependencies are:

 * Ruby 1.8.7
 * PostgreSQL 8.4 or higher.
 * Postgis 1.5.2
 * Bundler gem

== Installation (updated 8/18/2016)


* Install ruby-1.8.7-p374
* `bundle install`
* `gem uninstall sass`
* `gem uninstall compass`
* `gem install compass`
* `cp config/app_config.yml.sample config/app_config.yml`
* `npm install`
* `npm run bower install`
* `npm run grunt build`
* `npm run grunt`
* `bundle exec rails s`

## License
Copyright (c) 2010 - 2017, InterAction

This program is free software: you can redistribute it and/or modify
it under the terms of the **GNU Affero General Public License** as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details. The full license text may be found in the project's [LICENSE](LICENSE) file or at http://www.gnu.org/licenses/.


