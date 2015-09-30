class CreateGeolocationsProjectsJoinTable < ActiveRecord::Migration
  def self.up
    create_table :geolocations_projects, :id => false do |t|
      t.integer :geolocation_id
      t.integer :project_id
    end
    add_index :geolocations_projects, [:geolocation_id, :project_id]
  end

  def self.down
    drop_table :geolocations_projects
  end
end
