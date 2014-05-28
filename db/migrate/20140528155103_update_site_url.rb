class UpdateSiteUrl < ActiveRecord::Migration
  def self.up

    global_site = Site.find_by_name("global")
    # Change url from global.ngoaidmap.xxx to ngoaidmap.xxx
    # to go to global site when no sub-site is specified
    global_site.url = global_site.url.gsub("global.","")
    global_site.save
  end

  def self.down

    global_site = Site.find_by_name("global")
    global_site.url = "global." + global_site.url
    global_site.save
  end
end
