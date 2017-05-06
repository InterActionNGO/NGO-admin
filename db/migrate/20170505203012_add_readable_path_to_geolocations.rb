class AddReadablePathToGeolocations < ActiveRecord::Migration
  def self.up
      add_column :geolocations, :readable_path, :string
      
      Geolocation.find_each do |g|
        g.readable_path = [self.g0, self.g1, self.g2, self.g3, self.g4].compact.map{|g| Geolocation.where(:uid => g).first.try(:name)}.compact.reject{ |x| x.strip.empty? }.join('>')
        if g.save!
             puts "Success: added #{g.readable_path}"
         else
             puts "Failure: could save readable path for #{g.id}"
         end
      end
      puts 'Finished!'
  end

  def self.down
      remove_column :geolocations, :readable_path
  end
end
