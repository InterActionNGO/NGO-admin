class PopulateTagCounterValues < ActiveRecord::Migration
  def self.up
      Tag.find_each do |tag|
          puts "Updating count for tag: #{tag.name}"
         tag.count = tag.projects.uniq.size
         tag.save!
      end
      puts 'All finished.'
  end

  def self.down
  end
end
