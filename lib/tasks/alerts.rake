namespace :iom do

  namespace :alerts do

    desc 'Send an email alert to all project administration whose projects are about to end'
    task :projects_about_to_end => :environment do
      about_to_end = Project.where('end_date >= ? AND end_date <= ?', Time.now, 1.month.since.advance(:days => -1))

      to = {}
      about_to_end.each do |project|
        project.cached_sites.each do |site|
          email = begin
                    project.primary_organization.attributes_for_site(site)[:main_data_contact_email].presence || project.primary_organization.main_data_contact_email.presence || 'mappinginfo@interaction.org'
                  rescue
                    project.primary_organization.main_data_contact_email.presence || 'mappinginfo@interaction.org'
                  end

          to[email] = [] unless to.has_key?(email)
          to[email] << {
            :id           => project.id,
            :name         => project.name,
            :country_name => project.countries.map(&:name).join(', '),
            :end_date     => project.end_date.to_date
          }
          to[email].uniq!
        end
      end

      to.each { |email, projects| AlertsMailer.projects_about_to_end(email, projects).deliver }
    end

    desc 'Send an email alert to all managers who have not logged in in the last six months'
    task :six_months_since_last_login => :environment do
      User.where(<<-SQL, false, 6.months.ago).find_each do |user|
        (six_months_since_last_login_alert_sent IS NULL OR
         six_months_since_last_login_alert_sent = ?) AND
        (last_login IS NULL OR last_login < ?)
        SQL

        AlertsMailer.six_months_since_last_login(user).deliver
        user.update_attribute('six_months_since_last_login_alert_sent', true)
      end
    end

  end

end
