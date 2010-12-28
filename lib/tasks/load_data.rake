namespace :db do
  desc 'Remove,Create,Seed and load data'
  task :reset => %w(db:drop db:create db:migrate iom:data:load_countries db:seed iom:data:load_adm_levels iom:data:load_orgs iom:data:load_projects)

  desc 'reset 1'
  task :reset_1 => %w(db:drop db:create db:migrate iom:data:load_countries)

  desc 'reset 2'
  task :reset_2 => %w(db:seed iom:data:load_adm_levels iom:data:load_orgs iom:data:load_projects)
end

namespace :iom do
  namespace :data do
    desc "Load organizations and projects data"
    task :all => %w(load_adm_levels load_orgs load_projects)

    desc "load country data"
    task :load_countries => :environment do
      DB = ActiveRecord::Base.connection
      DB.execute 'DELETE FROM countries'
      system("unzip -o #{Rails.root}/db/data/countries/TM_WORLD_BORDERS-0.3.zip -d #{Rails.root}/db/data/countries/")
      system("shp2pgsql -d -s 4326 -gthe_geom -i -WLATIN1 #{Rails.root}/db/data/countries/TM_WORLD_BORDERS-0.3.shp public.tmp_countries | psql -Upostgres -diom_#{RAILS_ENV}")

      #Insert the country and get the value
      sql="INSERT INTO countries(\"name\",code,the_geom,iso2_code,iso3_code)
      SELECT name,iso3,the_geom,iso2,iso3 from tmp_countries"
      DB.execute sql

      DB.execute "UPDATE countries SET center_lat=y(ST_Centroid(the_geom)),center_lon=x(ST_Centroid(the_geom))"
      DB.execute "UPDATE countries SET the_geom_geojson=ST_AsGeoJSON(the_geom,6)"

      DB.execute 'DROP TABLE tmp_countries'
      system("rm -rf #{Rails.root}/db/data/countries/TM_WORLD_BORDERS-0.3.shp #{Rails.root}/db/data/countries/TM_WORLD_BORDERS-0.3.shx #{Rails.root}/db/data/countries/TM_WORLD_BORDERS-0.3.dbf #{Rails.root}/db/data/countries/TM_WORLD_BORDERS-0.3.prj #{Rails.root}/db/data/countries/Readme.txt")
    end

    desc "load 3th administrative level Haiti geo data. (Communes)"
    task :load_adm_levels => :environment do
      DB = ActiveRecord::Base.connection

      DB.execute 'DELETE FROM regions'

      #Import data from GADM (http://www.gadm.org/country)

      system("shp2pgsql -d -s 4326 -gthe_geom -i -WLATIN1 #{Rails.root}/db/data/regions/HTI_adm1.shp public.tmp_haiti_adm1 | psql -Upostgres -diom_#{RAILS_ENV}")

      system("shp2pgsql -d -s 4326 -gthe_geom -i -WLATIN1 #{Rails.root}/db/data/regions/HTI_adm2.shp public.tmp_haiti_adm2 | psql -Upostgres -diom_#{RAILS_ENV}")

      system("shp2pgsql -d -s 4326 -gthe_geom -i -WLATIN1 #{Rails.root}/db/data/regions/HTI_adm3.shp public.tmp_haiti_adm3 | psql -Upostgres -diom_#{RAILS_ENV}")

      country_id = Country.where("code=?","HTI").select(Country.custom_fields).first.id


      #Level1
      sql="insert into regions(\"name\",\"level\",country_id,the_geom,gadm_id)
      select name_1 as \"name\",1 as \"level\",#{country_id} as country_id,the_geom,id_1 from tmp_haiti_adm1"
      DB.execute sql

      #Level2
      sql="insert into regions(\"name\",\"level\",country_id,parent_region_id,the_geom,gadm_id)
      select name_2 as \"name\",2 as \"level\",#{country_id} as country_id,
      (select id from regions where gadm_id=adm2.id_1 and \"level\"=1 limit 1) as parent_id
      ,the_geom,id_2 from tmp_haiti_adm2 as adm2"
      DB.execute sql

      #Level3
      sql="insert into regions(\"name\",\"level\",country_id,parent_region_id,the_geom,gadm_id)
      select name_3 as \"name\",3 as \"level\",#{country_id} as country_id,
      (select id from regions where gadm_id=adm3.id_2 and \"level\"=2 limit 1) as parent_id
      ,the_geom,id_3 from tmp_haiti_adm3 as adm3"
      DB.execute sql

      DB.execute 'DROP TABLE tmp_haiti_adm1'
      DB.execute 'DROP TABLE tmp_haiti_adm2'
      DB.execute 'DROP TABLE tmp_haiti_adm3'

      DB.execute "UPDATE regions SET center_lat=y(ST_Centroid(the_geom)),center_lon=x(ST_Centroid(the_geom))"
      DB.execute "UPDATE regions SET the_geom_geojson=ST_AsGeoJSON(the_geom,6)"


      #Temporary matching for Google Map Charts
      DB.execute "UPDATE regions set code='HT-GR' WHERE name like 'Grand%' and level=1"
      DB.execute "UPDATE regions set code='HT-AR' WHERE name like '%Artibonite' and level=1"
      DB.execute "UPDATE regions set code='HT-NI' WHERE name='Nippes' and level=1"
      DB.execute "UPDATE regions set code='HT-ND' WHERE name='Nord' and level=1"
      DB.execute "UPDATE regions set code='HT-NE' WHERE name='Nord-Est' and level=1"
      DB.execute "UPDATE regions set code='HT-NO' WHERE name='Nord-Ouest' and level=1"
      DB.execute "UPDATE regions set code='HT-OU' WHERE name='Ouest' and level=1"
      DB.execute "UPDATE regions set code='HT-SD' WHERE name='Sud' and level=1"
      DB.execute "UPDATE regions set code='HT-SE' WHERE name='Sud-Est' and level=1"
      DB.execute "UPDATE regions set code='HT-CE' WHERE name='Centre' and level=1"
    end

    desc 'Load organizations data'
    task :load_orgs => :environment do
      DB = ActiveRecord::Base.connection
      DB.execute 'DELETE FROM organizations'
      #The haitiAidMap must be already created and it has ID=1

      csv_orgs = CsvMapper.import("#{Rails.root}/db/data/organizations_20_10_10.csv") do
        read_attributes_from_file
      end
      csv_orgs.each do |row|
        o = Organization.new
        puts row.organization
        o.name                    = row.organization
        o.website                 = row.website
        o.description             = row.about
        o.international_staff     = row.international_staff
        o.contact_name            = row.us_contact_name
        o.contact_position        = row.title
        o.contact_phone_number    = row.us_contact_phone
        o.contact_email           = row.email
        o.donation_address        = [row.donation_address_line_1,row.address_line_2].join("\n")
        o.city                    = row.city
        o.state                   = row.state
        o.zip_code                = row.zip_code
        o.donation_phone_number   = row.donation_phone_number
        o.donation_website        = row.donation_website
        o.estimated_people_reached= row.calculation_of_number_of_people_reached

        o.private_funding         = row.private_funding.to_money.dollars unless (row.private_funding.blank?)
        o.usg_funding             = row.usg_funding.to_money.dollars unless (row.usg_funding.blank?)
        o.other_funding           = row.other_funding.to_money.dollars unless (row.other_funding.blank?)

        budget=0
        budget = o.private_funding unless o.private_funding.nil?
        budget = budget + o.usg_funding  unless o.usg_funding.nil?
        budget = budget + o.other_funding  unless o.other_funding.nil?
        o.budget                  = budget unless budget==0


        o.private_funding_spent   = row.private_funding_spent.to_money.dollars unless (row.private_funding_spent.blank?)
        o.usg_funding_spent       = row.usg_funding_spent.to_money.dollars unless (row.usg_funding_spent.blank?)
        o.other_funding_spent     = row.other_funding_spent.to_money.dollars unless (row.other_funding_spent.blank?)
        o.spent_funding_on_relief = row._spent_on_relief
        o.spent_funding_on_reconstruction = row._spent_on_reconstruction
        o.percen_relief           = row._relief
        o.percen_reconstruction   = row._reconstruction
        o.national_staff          = row.national_staff
        o.media_contact_name      = row.media_contact_name
        o.media_contact_position  = row.media_contact_title
        o.media_contact_phone_number = row.media_contact_phone
        o.media_contact_email     = row.media_contact_email


        #Site specific attributes for Haiti
        o.attributes_for_site = {:organization_values => {:description=>row.organizations_work_in_haiti}, :site_id => 1}
        o.save!
      end
    end

    desc 'Load projects data'
    task :load_projects  => :environment do
      DB = ActiveRecord::Base.connection
      DB.execute 'DELETE FROM projects'
      DB.execute 'DELETE FROM projects_sectors'
      DB.execute 'DELETE FROM clusters_projects'
      DB.execute 'DELETE FROM organizations_projects'
      DB.execute 'DELETE FROM donations'
      DB.execute 'DELETE FROM donors'

      #Cache geocoding
      geo_cache={}

      csv_projs = CsvMapper.import("#{Rails.root}/db/data/projects_20_10_10.csv") do
        read_attributes_from_file
      end
      csv_projs.each do |row|
        p = Project.new
        o = Organization.find_by_name(row.organization)
        if o
          puts "PROJECT FOR: #{o.id}"
          p.primary_organization = o
          p.intervention_id           = row.ipc
          p.name                      = row.interv_title
          p.description               = row.interv_description
          p.activities                = row.interv_activities
          p.additional_information     = row.additional_information

          p.start_date = Date.strptime(row.est_start_date_mmddyyyy, '%m/%d/%Y') unless (row.est_start_date_mmddyyyy.blank?)
          if(row.est_end_date_mmddyyyy=="2/29/2010")
            row.est_end_date_mmddyyyy="3/1/2010"
          end
          p.end_date = Date.strptime(row.est_end_date_mmddyyyy, '%m/%d/%Y') unless (row.est_end_date_mmddyyyy.blank? or row.est_end_date_mmddyyyy=="Ongoing")

          p.budget                    = row.budget_usd.to_money.dollars unless (row.budget_usd.blank?)
          p.cross_cutting_issues      = row.crosscutting_issues
          p.implementing_organization = row.implementing_organizations
          p.partner_organizations     = row.partner_organizations
          p.estimated_people_reached  = row.number_of_people_reached_target
          p.target                    = row.target_groups
          p.contact_person            = row.contact_name
          p.contact_position          = row.contact_title
          p.contact_email             = row.contact_email
          p.website                   = row.website
          p.date_provided             = Date.strptime(row.date_provided_mmddyyyy, '%m/%d/%Y') unless (row.date_provided_mmddyyyy.blank?)
          p.date_updated              = Date.strptime(row.date_updated_mmddyyyy, '%m/%d/%Y') unless (row.date_updated_mmddyyyy.blank?)

          # Relations
          #########################

          # -->Clusters
          if(!row.clusters.blank?)
            parsed_clusters = row.clusters.split(",").map{|e|e.strip}
            parsed_clusters.each do |clus|
              p.clusters << Cluster.find_or_create_by_name(:name=>clus)
            end
          end

          # -->Sectors
          # they come separated by commas
          if(!row.ia_sectors.blank?)
            parsed_sectors = row.ia_sectors.split(",").map{|e|e.strip}
            parsed_sectors.each do |sec|
              p.sectors << Sector.find_or_create_by_name(:name=>sec)
            end
          end

          # -->Donor
          if(!row.donors.blank?)
            parsed_donors = row.donors.split(",").map{|e|e.strip}
            parsed_donors.each do |don|

              donor= Donor.where("name ilike ?",don).first
              if(!donor)
                donor = Donor.new
                donor.name =don
                donor.save!
              end
              donation = Donation.new
              donation.project = p
              donation.donor = donor
              p.donations << donation
            end
          end

          p.save!

          # -->Country
          if (!row.country.blank?)
            country= Country.where("name ilike ?",row.country).select(Country.custom_fields).first
            if(country)
              p.countries  << country
            else
              puts "ALERT: COUNTRY NOT FOUND #{row.country}"
            end
          end
          puts "."

          #Geo data
          reg1=nil
          if(!row._1st_administrative_level_department.blank?)
            parsed_adm1 = row._1st_administrative_level_department.split(",").map{|e|e.strip}
            parsed_adm1.each do |region_name|
              reg1 = Region.where("name ilike ? and level=?",region_name,1).select(Region.custom_fields).first
              if(reg1)
                p.regions  << reg1
              else
                puts "ALERT: REGION LEVEL 1 NOT FOUND #{region_name}"
              end
            end
          end
          if p.regions.empty?
            puts "[error] empty regions"
            next
          end
          puts "."


          reg2=nil
          if(!row._2nd_administrative_level_arrondissement.blank?)
            parsed_adm2 = row._2nd_administrative_level_arrondissement.split(",").map{|e|e.strip}
            parsed_adm2.each do |region_name|
              reg2 = Region.where("name ilike ? and level=?",region_name,2).select(Region.custom_fields).first
              if(reg2)
                p.regions  << reg2
              else
                puts "ALERT: REGION LEVEL 2 NOT FOUND #{region_name}"
              end

            end
          end
          puts "."

          multi_point=""
          reg3=nil
          if(!row._3rd_administrative_level_commune.blank?)
            parsed_adm3 = row._3rd_administrative_level_commune.split(",").map{|e|e.strip}
            locations = Array.new
            parsed_adm3.each do |region_name|
              reg3 = Region.where("name ilike ? and level=?",region_name,3).select(Region.custom_fields).first
              if(reg3)
                p.regions  << reg3
                sql="select ST_AsText(ST_PointOnSurface(the_geom)) as point from regions where id=#{reg3.id}"
                res = DB.execute(sql).first["point"].delete("POINT(").delete(")")
                locations << res
              else
                puts "ALERT: REGION LEVEL 3 NOT FOUND #{region_name}"
              end
            end

            multi_point = "ST_MPointFromText('MULTIPOINT(#{locations.join(',')})',4326)" unless (locations.length<1)
          end
          puts "."

          #save the Geom that we created before
          if(!multi_point.blank?)
            sql="UPDATE projects SET the_geom=#{multi_point} WHERE id=#{p.id}"
            DB.execute sql
          end

        else
          puts "NOT FOUND #{row.organization}"
        end
      end

    end
  end
end
