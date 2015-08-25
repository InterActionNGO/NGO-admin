namespace :iom do
  namespace :sectors do
    desc 'Update sectors for IATI'
    task :update => :environment do
      update_and_rename_existing_sectors
      update_existing_sectors
      create_new_sectors
      puts "done."
    end
  end
end
def update_and_rename_existing_sectors
  puts "updating sectors with new names"
  sectors = ["Communications", "Disaster Management", "Peace and Security", "Safety Nets"]
  new_sectors = [["Communications / Technology","1","22020"],["Disaster Prevention and Preparedness","1","74010"],["Conflict Prevention and Resolution / Peace and Security","1","15220"],["Social Services", "1", "16050"]]
  sectors.each do |s,i|
    if sector = Sector.find_by_name(s)
      sector.oec_dac_name = new_sectors[i][0]
      sector.sector_vocab_code = new_sectors[i][1]
      sector.oec_dac_purpose_code = new_sectors[i][2]
      sector.save!
    end
  end
end
def update_existing_sectors
  puts "updating existing sectors"
  sectors = ["Agriculture", "Economic Recovery and Development", "Education", "Environment", "Food Aid", "Health", "Human Rights Democracy and Governance", "Protection", "Shelter and Housing", "Water Sanitation and Hygiene", "Other"]
  new_sectors = [["1",""], ["1",""], ["1",""], ["1",""], ["1",""], ["1",""], ["1",""], ["1",""], ["1",""], ["1",""], ["1",""], ["1",""], ["1",""]]
  sectors.each do |s,i|
    if sector = Sector.find_by_name(s)
      sector.oec_dac_name = sector.name
      sector.sector_vocab_code = new_sectors[i][0]
      sector.oec_dac_purpose_code = new_sectors[i][1]
      sector.save!
    end
  end
end
def create_new_sectors
  puts "creating new sectors"
  new_sectors = [["","1",""], ["","1",""], ["","1",""], ["","1",""], ["","1",""], ["","1",""], ["","1",""], ["","1",""], ["","1",""], ["","1",""], ["","1",""], ["","1",""], ["","1",""]]
  new_sectors.each do |s,i|
    sector = Sector.new
    sector.name = new_sectors[i][0]
    sector.oec_dac_name = new_sectors[i][0]
    sector.sector_vocab_code = new_sectors[i][1]
    sector.oec_dac_purpose_code = new_sectors[i][2]
    sector.save!
  end
end
