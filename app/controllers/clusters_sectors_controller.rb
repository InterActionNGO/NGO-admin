class ClustersSectorsController < ApplicationController

  layout :sites_layout
  caches_action :show, :expires_in => 300, :cache_path => Proc.new { |c| c.params }

  def show
    if params[:location_id].present?
      case params[:location_id]
      when String
        @filter_by_location = params[:location_id].split('/')
      when Array
        @filter_by_location = params[:location_id]
      end
    end

    @carry_on_filters = {}
    @carry_on_filters[:location_id] = @filter_by_location if @filter_by_location.present?

    if params[:id].to_i <= 0
      render_404
      return
    end

    if(request.url.match(/clusters/))
      # clusters
      render_404 and return unless @site.navigate_by_cluster?
      @data = Cluster.find(params[:id].to_i)

      projects_custom_find_options = {
        :cluster       => @data.id,
        :per_page      => 10,
        :page          => params[:page],
        :order         => 'created_at DESC',
        :start_in_page => params[:start_in_page]
      }

      if @filter_by_location.present? && @site.navigate_by_regions? && @filter_by_location.size > 1
        projects_custom_find_options[:cluster_region_id] = @filter_by_location[1..-1].join(',').last
      elsif @filter_by_location.present? && @site.navigate_by_country? && @filter_by_location.size >= 1
        projects_custom_find_options[:cluster_country_id] = @filter_by_location.first
      end
    else
      # sectors
      render_404 and return unless @site.navigate_by_sector?
      @data = Sector.find(params[:id].to_i)

      projects_custom_find_options = {
        :sector        => @data.id,
        :per_page      => 10,
        :page          => params[:page],
        :order         => 'created_at DESC',
        :start_in_page => params[:start_in_page]
      }

      if @filter_by_location.present?
        if @filter_by_location.size > 1
          projects_custom_find_options[:sector_region_id] = @filter_by_location.last
        else
          projects_custom_find_options[:sector_country_id] = @filter_by_location.first
        end
      end
    end

    @projects = Project.custom_find @site, projects_custom_find_options

    @cluster_sector_projects_count = @data.total_projects(@site, @filter_by_location)

    if @filter_by_location.present?
      @location_name = if @filter_by_location.size > 1
        region = Region.where(:id => @filter_by_location.last).first
        "#{region.country.name}/#{region.name}" rescue ''
      else
        "#{Country.where(:id => @filter_by_location.first).first.name}"
      end
      @filter_name = "#{@cluster_sector_projects_count} projects in #{@location_name}"
    end

    respond_to do |format|
      format.html do

        if @data.is_a?(Cluster)
          carry_on_url = cluster_path(@data, @carry_on_filters.merge(:location_id => ''))
          if @site.geographic_context_country_id
            location_filter = "where r.id = #{@filter_by_location.last}" if @filter_by_location

            # Get the data for the map depending on the region definition of the site (country or region)
            sql="select r.id,r.name,count(ps.*) as count,r.center_lon as lon,r.center_lat as lat,r.name,'#{carry_on_url}'||r.path as url,r.code,
                (select count(*) from data_denormalization where regions_ids && ('{'||r.id||'}')::integer[] and (end_date is null OR end_date > now()) and site_id=#{@site.id}) as total_in_region
            from regions as r
              inner join projects_regions as pr on r.id=pr.region_id and r.level=#{@site.level_for_region}
              inner join projects_sites as ps on pr.project_id=ps.project_id and ps.site_id=#{@site.id}
              inner join projects as p on ps.project_id=p.id and (p.end_date is null OR p.end_date > now())
              inner join clusters_projects as cp on cp.project_id=p.id and cp.cluster_id=#{params[:id].sanitize_sql!.to_i}
              #{location_filter}
              group by r.id,r.name,lon,lat,r.name,url,r.code"
          else
             location_filter = "where c.id = #{@filter_by_location.first}" if @filter_by_location
             sql="select c.id,c.name,count(ps.*) as count,c.center_lon as lon,c.center_lat as lat,c.name,'#{carry_on_url}'||c.id as url,
                  (select count(*) from data_denormalization where countries_ids && ('{'||c.id||'}')::integer[] and (end_date is null OR end_date > now()) and site_id=#{@site.id}) as total_in_region
              from countries as c
                inner join countries_projects as cp on c.id=cp.country_id
                inner join projects_sites as ps on cp.project_id=ps.project_id and ps.site_id=#{@site.id}
                inner join projects as p on ps.project_id=p.id and (p.end_date is null OR p.end_date > now())
                inner join clusters_projects as cpr on cpr.project_id=p.id and cpr.cluster_id=#{params[:id].sanitize_sql!.to_i}
                #{location_filter}
                group by c.id,c.name,lon,lat,c.name,url"
          end
        else
          carry_on_url = sector_path(@data, @carry_on_filters.merge(:location_id => ''))
          if @site.geographic_context_country_id
            location_filter = "where r.id = #{@filter_by_location.last}" if @filter_by_location

            # Get the data for the map depending on the region definition of the site (country or region)
            sql="select r.id,r.name,count(ps.*) as count,r.center_lon as lon,r.center_lat as lat,r.name,
            CASE WHEN count(distinct ps.project_id) > 1 THEN
                '#{carry_on_url}'||r.path
            ELSE
                '/projects/'||(array_to_string(array_agg(ps.project_id),''))
            END as url,
            r.code,
                (select count(*) from data_denormalization where regions_ids && ('{'||r.id||'}')::integer[] and (end_date is null OR end_date > now()) and site_id=#{@site.id}) as total_in_region
            from regions as r
              inner join projects_regions as pr on r.id=pr.region_id and r.level=#{@site.level_for_region}
              inner join projects_sites as ps on pr.project_id=ps.project_id and ps.site_id=#{@site.id}
              inner join projects as p on ps.project_id=p.id and (p.end_date is null OR p.end_date > now())
              inner join projects_sectors as pse on pse.project_id=p.id and pse.sector_id=#{params[:id].sanitize_sql!.to_i}
              #{location_filter}
              group by r.id,r.name,lon,lat,r.path,r.code"
          else

            if @filter_by_location
              region_location_filter = @filter_by_location.size == 1 ? "r.country_id = #{@filter_by_location.first}" : "r.id = #{@filter_by_location.last}"
              country_location_filter = @filter_by_location.size == 1 ? "c.id = #{@filter_by_location.first}" : "c.id = #{@filter_by_location.last}"

              sql = <<-SQL
                SELECT r.id AS id,
                       r.name as region_name,
                       count(ps.*) AS count,
                       r.center_lon AS lon,
                       r.center_lat AS lat,
                       c.name as country_name,
                       CASE
                           WHEN COUNT(DISTINCT ps.project_id) > 1 THEN '#{carry_on_url}'||r.path
                           ELSE '/projects/'||(array_to_string(array_agg(ps.project_id),''))
                       END AS url,
                  (SELECT COUNT(*)
                   FROM data_denormalization
                   WHERE regions_ids && ('{'||r.id||'}')::integer[] and (end_date is null OR end_date > now()) and site_id=#{@site.id}) as total_in_region
                   from regions as r
                   inner join projects_regions as pr on r.id=pr.region_id
                   inner join projects_sites as ps on pr.project_id=ps.project_id and ps.site_id=#{@site.id}
                    inner join projects as p on ps.project_id=p.id and (p.end_date is null OR p.end_date > now())
                    inner join projects_sectors as pse on pse.project_id=p.id and pse.sector_id=#{params[:id].sanitize_sql!.to_i}
                    inner join countries c on r.country_id = c.id
                    where #{region_location_filter}
                     group by r.id,r.name,lon,lat,r.path,c.name
                UNION
                 SELECT c.id as id,
                 c.name as name,
                 count(ps.*) as count,
                 c.center_lon as lon,
                 c.center_lat as lat,
                 c.name as country_name,
                 CASE WHEN count(distinct ps.project_id) > 1 THEN '#{carry_on_url}'||c.id
                 ELSE '/projects/'||(array_to_string(array_agg(ps.project_id),''))
                 END as url,
                 (select count(*) from data_denormalization
                 where countries_ids && ('{'||c.id||'}')::integer[] AND (end_date IS NULL OR end_date > now()) AND site_id=#{@site.id}) AS total_in_region

                  FROM countries AS c
                  INNER JOIN countries_projects AS cp ON c.id=cp.country_id
                  INNER JOIN projects_sites AS ps ON cp.project_id=ps.project_id
                  AND ps.site_id=#{@site.id}
                  INNER JOIN projects AS p ON ps.project_id=p.id
                  AND (p.end_date IS NULL
                       OR p.end_date > now())
                  INNER JOIN projects_sectors AS pse ON pse.project_id=p.id
                  AND pse.sector_id=#{params[:id].sanitize_sql!.to_i}
                  AND #{country_location_filter}
                  GROUP BY c.id, c.name, lon, lat, c.name
              SQL
            else
              sql="select c.id,c.name,count(ps.*) as count,c.center_lon as lon,c.center_lat as lat,c.name,
                CASE WHEN count(distinct ps.project_id) > 1 THEN
                    '#{carry_on_url}'||c.id
                ELSE
                    '/projects/'||(array_to_string(array_agg(ps.project_id),''))
                END as url,
                    (select count(*) from data_denormalization where countries_ids && ('{'||c.id||'}')::integer[] and (end_date is null OR end_date > now()) and site_id=#{@site.id}) as total_in_region
                from countries as c
                  inner join countries_projects as cp on c.id=cp.country_id
                  inner join projects_sites as ps on cp.project_id=ps.project_id and ps.site_id=#{@site.id}
                  inner join projects as p on ps.project_id=p.id and (p.end_date is null OR p.end_date > now())
                  inner join projects_sectors as pse on pse.project_id=p.id and pse.sector_id=#{params[:id].sanitize_sql!.to_i}
                  group by c.id,c.name,lon,lat,c.name"
            end
          end
        end



        result = ActiveRecord::Base.connection.execute(sql)

        @map_data = result.map do |r|
          uri = URI.parse(r['url'])
          params = Hash[uri.query.split('&').map{|p| p.split('=')}] rescue {}
          params['force_site_id'] = @site.id unless @site.published?
          uri.query = params.to_a.map{|p| p.join('=')}.join('&')
          r['url'] = uri.to_s
          r
        end.to_json
        @overview_map_chco = @site.theme.data[:overview_map_chco]
        @overview_map_chf = @site.theme.data[:overview_map_chf]
        @overview_map_marker_source = @site.theme.data[:overview_map_marker_source]

        areas= []
        data = []
        @map_data_max_count=0
        result.each do |c|
          areas << c["code"]
          data  << c["count"]
          if(@map_data_max_count < c["count"].to_i)
            @map_data_max_count=c["count"].to_i
          end
        end
        #@chld = areas.join("|")
        @chld = ""
        #@chd  = "t:"+data.join(",")
        @chd = ""

      end
      format.js do
        render :update do |page|
          page << "$('#projects_view_more').remove();"
          page << "$('#projects').html('#{escape_javascript(render(:partial => 'projects/projects'))}');"
          page << "IOM.ajax_pagination();"
          page << "resizeColumn();"
        end
      end
      format.csv do
        send_data Project.to_csv(@site, projects_custom_find_options),
          :type => 'text/plain; charset=utf-8; application/download',
          :disposition => "attachment; filename=#{@data.name.gsub(/[^0-9A-Za-z]/, '')}_projects.csv"

      end
      format.xls do
        send_data Project.to_excel(@site, projects_custom_find_options),
          :type        => 'application/vnd.ms-excel',
          :disposition => "attachment; filename=#{@data.name.gsub(/[^0-9A-Za-z]/, '')}_projects.xls"
      end
      format.kml do
        @projects_for_kml = Project.to_kml(@site, projects_custom_find_options)
      end
    end
  end

end
