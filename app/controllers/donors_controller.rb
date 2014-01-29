class DonorsController < ApplicationController

  layout 'site_layout'

  def show
    @donor = Donor.find(params[:id])
    @donor.attributes = @donor.attributes_for_site(@site)

    @projects = Project.custom_find @site, :donor_id => @donor.id,
                                           :per_page => 10,
                                           :page => params[:page],
                                           :order => 'created_at DESC',
                                           :start_in_page => params[:start_in_page]

    @map_data = []

    @filter_by_category = if params[:category_id].present?
                            params[:category_id].to_i
                          else
                            nil
                          end
    @filter_by_location = if params[:location_id].present?
                            case params[:location_id]
                            when String
                              params[:location_id].split('/').map(&:to_i)
                            else
                              params[:location_id].map(&:to_i)
                            end
                          else
                            nil
                          end
    if @filter_by_category.present?
      if @site.navigate_by_cluster?
        category_join = "inner join clusters_projects as cp on cp.project_id = p.id and cp.cluster_id = #{@filter_by_category}"
      else
        category_join = "inner join projects_sectors as pse on pse.project_id = p.id and pse.sector_id = #{@filter_by_category}"
      end
    end

    if @site.geographic_context_country_id
      location_filter = "and r.id = #{@filter_by_location.last}" if @filter_by_location


      sql="select r.id,count(distinct ps.project_id) as count,r.name,r.center_lon as lon,r.center_lat as lat,
                  CASE WHEN count(distinct ps.project_id) > 1 THEN
                      r.path
                  ELSE
                      '/projects/'||(array_to_string(array_agg(ps.project_id),''))
                  END as url

                  ,r.code,
                  (select count(*) from data_denormalization where regions_ids && ('{'||r.id||'}')::integer[] and (end_date is null OR end_date > now()) and site_id=#{@site.id}) as total_in_region
            from ((((
              projects as p inner join donations as dn on dn.project_id = p.id and dn.donor_id=#{params[:id].sanitize_sql!.to_i})
              inner join projects_sites as ps on p.id=ps.project_id and ps.site_id=#{@site.id})
              inner join projects as prj on ps.project_id=prj.id and (prj.end_date is null OR prj.end_date > now())
              inner join projects_regions as pr on pr.project_id=p.id)
              inner join regions as r on pr.region_id=r.id and r.level=#{@site.level_for_region} #{location_filter})
              #{category_join}
            group by r.id,r.path,lon,lat,r.name,r.code"
    else
      if @filter_by_location
        sql = if @filter_by_location.size == 1
                <<-SQL
                  SELECT r.id,
                         count(ps.project_id) AS count,
                         r.name,
                         r.center_lon AS lon,
                         r.center_lat AS lat,
                         r.name,
                         CASE WHEN count(ps.project_id) > 1 THEN
                           r.path
                         ELSE
                           '/projects/'||(array_to_string(array_agg(ps.project_id),''))
                         END AS url,
                         r.code
                  FROM projects_regions AS pr
                  INNER JOIN projects_sites AS ps ON pr.project_id=ps.project_id AND ps.site_id=#{@site.id}
                  INNER JOIN projects AS p ON pr.project_id=p.id AND (p.end_date is NULL OR p.end_date > now())
                  INNER JOIN regions AS r ON pr.region_id=r.id AND r.level=#{@site.levels_for_region.min} AND r.country_id=#{@filter_by_location.first}
                  INNER JOIN donarions on donations.project_id = p.id
                  #{category_join}
                  WHERE dn.donor_id = #{params[:id].sanitize_sql!.to_i}
                  GROUP BY r.id,r.name,lon,lat,r.name,r.path,r.code
                SQL
        else
            <<-SQL
              SELECT r.id,
                     count(ps.project_id) AS count,
                     r.name,
                     r.center_lon AS lon,
                     r.center_lat AS lat,
                     r.name,
                     CASE WHEN count(ps.project_id) > 1 THEN
                       r.path
                     ELSE
                       '/projects/'||(array_to_string(array_agg(ps.project_id),''))
                     END AS url,
                     r.code
              FROM projects_regions AS pr
              INNER JOIN projects_sites AS ps ON pr.project_id=ps.project_id AND ps.site_id=#{@site.id}
              INNER JOIN projects AS p ON pr.project_id=p.id AND (p.end_date is NULL OR p.end_date > now())
              INNER JOIN regions AS r ON pr.region_id=r.id AND r.level=#{@site.levels_for_region.min} AND r.country_id=#{@filter_by_location.shift} AND r.id IN (#{@filter_by_location.join(',')})
              #{category_join}
              WHERE p.primary_organization_id = #{params[:id].sanitize_sql!.to_i}
              GROUP BY r.id,r.name,lon,lat,r.name,r.path,r.code
            SQL
        end
      else
        sql="select c.id,count(distinct ps.project_id) as count,c.name,c.center_lon as lon,
                    c.center_lat as lat,c.name,
                    CASE WHEN count(distinct ps.project_id) > 1 THEN
                        c.id
                    ELSE
                        '/projects/'||(array_to_string(array_agg(ps.project_id),''))
                    END as url,
                    c.iso2_code as code,
                    (select count(*) from data_denormalization where countries_ids && ('{'||c.id||'}')::integer[] and (end_date is null OR end_date > now()) and site_id=#{@site.id}) as total_in_region
              from ((((
                projects as p inner join organizations as o on o.id=p.primary_organization_id and o.id=#{params[:id].sanitize_sql!.to_i})
                inner join projects_sites as ps on p.id=ps.project_id and ps.site_id=#{@site.id}) inner join countries_projects as cp on cp.project_id=p.id)
                inner join projects as prj on ps.project_id=prj.id and (prj.end_date is null OR prj.end_date > now())
                inner join countries as c on cp.country_id=c.id)
                #{category_join}
              group by c.id,c.name,lon,lat,c.name,c.iso2_code"
      end

    end
    result=ActiveRecord::Base.connection.execute(sql)
    # @map_data = result.map do |r|
    #   uri = URI.parse(r['url'])
    #   params = Hash[uri.query.split('&').map{|p| p.split('=')}] rescue {}
    #   params['force_site_id'] = @site.id unless @site.published?
    #   uri.query = params.to_a.map{|p| p.join('=')}.join('&')
    #   r['url'] = uri.to_s
    #   r
    # end.to_json
    
    result.each do |r|
      # debugger
      @map_data << {:name => r['name'], :lon => r['lon'], :lat => r['lat'], :count => r['total_in_region'], :url => r['url']}
    end
    @map_data = @map_data.to_json

    respond_to do |format|
      format.html
      format.js do
        render :update do |page|
          page << "$('#projects_view_more').html('#{escape_javascript(render(:partial => 'donors/pagination'))}');"
          page << "$('#projects').append('#{escape_javascript(render(:partial => 'donors/projects'))}');"
          page << "IOM.ajax_pagination();"
          page << "resizeColumn();"
        end
      end
    end
  end

end
