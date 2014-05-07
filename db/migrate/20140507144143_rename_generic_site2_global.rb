class RenameGenericSite2Global < ActiveRecord::Migration
  def self.up
    Site.where(name: 'generic').update_all(name: 'global')
  end

  def self.down
    Site.where(name: 'global').update_all(name: 'generic')
  end
end
