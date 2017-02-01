namespace :iom do
  namespace :projects do

    desc 'Add tag "executive_order_20170127" to certain projects'
    
    task :add_eo20170127_tag => :environment do
            
        name = 'executive_order_20170127'
        tag = Tag.where(:name => name)
        if tag.empty?
            tag = []
            tag.push(Tag.create(:name => name))
        end
        
        # Get all the projects in the 7 countries that do not already have the tag 
        projects = Project.find_by_sql("with t1 as (select p.id as id, ARRAY['executive_order_20170127'] <@ ARRAY[array_agg(t.name)]::text[] as has_tag from projects p left join projects_tags pt on pt.project_id = p.id left join tags t on t.id = pt.tag_id group by p.id) select distinct p.id from projects p join geolocations_projects gp on gp.project_id = p.id join geolocations g on g.id = gp.geolocation_id join t1 on t1.id = p.id where g.country_code in ('IR','IQ','LY','SO','SD','SY','YE') and t1.has_tag = false")
        
        # Add the tag 
        projects.each do |p|
            p.tags << tag
        end

    end
  end
end
