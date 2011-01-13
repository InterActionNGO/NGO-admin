class PreCalculateRegionsCentroids < ActiveRecord::Migration
  def self.up
    execute "UPDATE regions SET center_lat=y(ST_Centroid(the_geom)),center_lon=x(ST_Centroid(the_geom))"
    execute "UPDATE countries SET center_lat=y(ST_Centroid(the_geom)),center_lon=x(ST_Centroid(the_geom))"
  end

  def self.down
  end
end
