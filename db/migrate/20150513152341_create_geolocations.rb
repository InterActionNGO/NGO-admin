class CreateGeolocations < ActiveRecord::Migration
  def change
    create_table :geolocations do |t|
      t.integer :geonameid
      t.string :name
      t.float :latitude
      t.float :longitude
      t.string :fclass
      t.string :fcode
      t.string :country_code
      t.string :country_name
      t.integer :country_geonameid
      t.string :cc2
      t.string :admin1
      t.string :admin2
      t.string :admin3
      t.string :admin4
      t.string :provider, default: 'Geonames'
      t.integer :adm_level

      t.timestamps null: false
    end
    add_index :geolocations, :geonameid
    add_index :geolocations, :admin1
    add_index :geolocations, :admin2
    add_index :geolocations, :admin3
    add_index :geolocations, :admin4
  end
end
