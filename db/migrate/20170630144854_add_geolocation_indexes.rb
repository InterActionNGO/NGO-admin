class AddGeolocationIndexes < ActiveRecord::Migration
  def self.up
      add_index :geolocations, :id, :unique => true
      add_index :geolocations, :readable_path
  end

  def self.down
      remove_index :geolocations, :id
      remove_index :geolocations, :readable_path
  end
end
