class AddGeolocationsIndexes < ActiveRecord::Migration
  def self.up
    add_index :geolocations, :g0
    add_index :geolocations, :g1
    add_index :geolocations, :g2
    add_index :geolocations, :g3
    add_index :geolocations, :g4
    add_index :geolocations, :country_uid
    add_index :geolocations, :country_name
  end
end
