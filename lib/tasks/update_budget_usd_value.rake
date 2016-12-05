namespace :iom do
  desc "Update the cached budget_usd value on existing records"
  task :update_budget_usd => :environment do
    puts "Starting..."

    begin
      Project.where("projects.budget_usd IS NULL").
        where("projects.budget_currency IS NOT NULL").
        where("projects.budget IS NOT NULL").
        where('projects.budget_currency = ?', "USD").
        update_all("budget_usd = projects.budget")
    rescue => e
      puts " [ERROR] Updating all USD records #{e.inspect}"
    end

    projects = Project.where("projects.budget_usd IS NULL").
      where("projects.budget_currency IS NOT NULL").
      where("projects.budget IS NOT NULL").
      where('projects.budget_currency != ?', "USD").
      where('budget_value_date IS NOT NULL')

    projects.each do |project|
      begin
        project.update_attribute(:budget_usd, project.budget_coverted_to_usd)
        puts " * Project(#{project.id}) with a budget #{project.budget} in #{project.budget_currency} is $#{project.budget_usd}"
      rescue => e
        puts " [ERROR] Project(#{project.id}) had an error #{e.inspect} - #{project.errors.full_messages.inspect}"
      end
    end

    puts "Done!"
  end
end
