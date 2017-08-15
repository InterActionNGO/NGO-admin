class SetGlobalGeolocationOnExistingProjects < ActiveRecord::Migration
  def self.up
    # Set existing global scope projects with new global geolocation
      Project.where(:geographical_scope => 'global').each do |p|
          p.save!
      end
  end

  def self.down
  end
end
