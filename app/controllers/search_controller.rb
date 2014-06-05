class SearchController < ApplicationController

  layout 'site_layout'

  def index
    where  = ["site_id=#{@site.id}"]
    limit = 20
    @current_page = params[:page] ? params[:page].to_i : 1
    @clusters = @regions = @filtered_regions = @filtered_sectors = @filtered_clusters = @filtered_organizations = @filtered_donors = []
    @navigate_by_cluster = @site.navigate_by_cluster?

    p params[:regions_ids]

    if params[:regions_ids].present?
      @filtered_regions = Region.find_by_sql("select r.id, r.name as title, c.name as subtitle from regions as r inner join countries as c on c.id = r.country_id where r.id in (#{params[:regions_ids].join(",")})")
      filtered_regions_where = "where r.id not in (#{params[:regions_ids].join(",")})"
      where << params[:regions_ids].map{|region_id| "regions_ids && ('{'||#{region_id}||'}')::integer[]"}.join(' OR ')

      #p params[:regions_ids]
      #p where
    end

    if params[:sectors_ids].present?
      @filtered_sectors = Sector.find_by_sql("select s.id, s.name as title from sectors as s where s.id in (#{params[:sectors_ids].join(",")})")
      filtered_sectors_where = "where s.id not in (#{params[:sectors_ids].join(",")})"
      where << params[:sectors_ids].map{|sector_id| "sector_ids && ('{'||#{sector_id}||'}')::integer[]"}.join(' OR ')

      #p where
    end

    if params[:clusters_ids].present?
      @filtered_clusters = Cluster.find_by_sql("select c.id, c.name as title from clusters as c where c.id in (#{params[:clusters_ids].join(",")})")
      filtered_clusters_where = "where c.id not in (#{params[:clusters_ids].join(",")})"
      where << params[:clusters_ids].map{|cluster_id| "cluster_ids && ('{'||#{cluster_id}||'}')::integer[]"}.join(' OR ')
    end

    if params[:organizations_ids].present?
      @filtered_organizations = Cluster.find_by_sql("select o.id, o.name as title from organizations as o where o.id in (#{params[:organizations_ids].join(",")})")
      filtered_organizations_where = "where o.id not in (#{params[:organizations_ids].join(",")})"
      where << "organization_id IN (#{params[:organizations_ids].join(",")})"
    end

    if params[:donors_ids].present?
      @filtered_donors = Donor.find_by_sql("select d.id, d.name as title from donors as d where d.id in (#{params[:donors_ids].join(",")})")
      filtered_donors_where = "where d.id not in (#{params[:donors_ids].join(",")})"
      where << params[:donors_ids].map{|donor_id| "donors_ids && ('{'||#{donor_id}||'}')::integer[]"}.join(' OR ')
    end

    if params[:status].present? and params[:status] != 'Any'
      case params[:status]
        when 'Active'
          then where << "(end_date is null OR end_date > now())"
        when 'Inactive'
          then where << "end_date < now()"
      end
    end

    if params[:date]
      start_month = params[:date][:start_month]
      start_year  = params[:date][:start_year]
      end_month   = params[:date][:end_month]
      end_year    = params[:date][:end_year]

      if start_month.present? && start_year.present?
        start_month = start_month.sanitize_sql!.to_i
        start_year = start_year.sanitize_sql!.to_i
        @start_date = Date.new(start_year, start_month, 1)
        where << "start_date >= '#{@start_date.strftime('%Y-%m-%d')}'"
      elsif start_month.blank? && start_year.present?
        start_year = start_year.sanitize_sql!.to_i
        @start_date = Date.new(start_year, 1, 1)
        where << "start_date >= '#{@start_date.strftime('%Y-%m-%d')}'"
      end

      if end_month.present? && end_year.present?
        end_month = end_month.sanitize_sql!.to_i
        end_year = end_year.sanitize_sql!.to_i
        @end_date = Date.new(end_year, end_month, 1)
        where << "end_date <= '#{@end_date.strftime('%Y-%m-%d')}'"
      elsif end_month.blank? && end_year.present?
        end_year = end_year.sanitize_sql!.to_i
        @end_date = Date.new(end_year, 12, 31)
        where << "end_date <= '#{@end_date.strftime('%Y-%m-%d')}'"
      end
    end

    if params[:q].present?
      q = "%#{params[:q].sanitize_sql!}%"
      where << "(project_name ilike '#{q}' OR
                 project_description ilike '#{q}' OR
                 organization_name ilike '#{q}' OR
                 sectors ilike '#{q}' OR
                 regions ilike '#{q}' )"
    end

    where << "(end_date is null OR end_date >= now())"

    where = where.present? ? "WHERE #{where.join(' AND ')}" : ''

    sql = "select * from data_denormalization as dn
              #{where}
              order by created_at DESC
              limit #{limit} offset #{limit * (@current_page - 1)}"

    @projects = ActiveRecord::Base.connection.execute(sql)

    sql_count = "select count(*) as count from data_denormalization #{where}"
    @total_projects = ActiveRecord::Base.connection.execute(sql_count).first['count'].to_i
    @total_pages = (@total_projects.to_f / limit.to_f).ceil

    #TODO: I am not taking in consideration the search on organization and location when using the facets.

    respond_to do |format|
      format.html do
        q_filter = q.present?? "AND (p.name ilike '#{q}' OR p.description ilike '#{q}')" : ''
        # cluster / sector Facet
        if @site.navigate_by_cluster?
          sql = <<-SQL
            SELECT DISTINCT c.id,c.name AS title
            FROM clusters AS c
            INNER JOIN clusters_projects AS cp ON c.id=cp.cluster_id
            INNER JOIN projects_sites AS ps ON cp.project_id=ps.project_id AND ps.site_id=#{@site.id}
            INNER JOIN projects AS p ON ps.project_id=p.id AND (p.end_date is NULL OR p.end_date > now()) #{q_filter}
            #{filtered_clusters_where}
          SQL
          @clusters = Cluster.find_by_sql(sql)
        else
          sql = <<-SQL
            SELECT DISTINCT s.id,s.name AS title
            FROM sectors AS s
            INNER JOIN projects_sectors AS ps ON s.id=ps.sector_id
            INNER JOIN projects_sites AS psi ON psi.project_id=ps.project_id AND psi.site_id=#{@site.id}
            INNER JOIN projects AS p ON psi.project_id=p.id AND (p.end_date is NULL OR p.end_date > now()) #{q_filter}
            #{filtered_sectors_where}
          SQL
          @sectors = Sector.find_by_sql(sql)
        end

        sql = <<-SQL
          SELECT DISTINCT
            r.id, r.name AS title,
            CASE WHEN ps.site_id = 1 THEN null ELSE c.name END AS subtitle
          FROM regions AS r
          INNER JOIN projects_regions AS pr ON r.id=pr.region_id AND r.level=#{@site.level_for_region}
          INNER JOIN projects_sites AS ps ON pr.project_id=ps.project_id AND ps.site_id=#{@site.id}
          INNER JOIN projects AS p ON ps.project_id=p.id AND (p.end_date is NULL OR p.end_date > now()) #{q_filter}
          INNER JOIN countries AS c ON c.id = r.country_id
          #{filtered_regions_where}
          ORDER BY subtitle, title
        SQL
        @regions = Region.find_by_sql(sql)

        sql = <<-SQL
          SELECT DISTINCT o.id, o.name AS title
          FROM organizations AS o
          INNER JOIN projects AS p ON (p.end_date is NULL OR p.end_date > now()) AND p.primary_organization_id = o.id #{q_filter}
          INNER JOIN projects_sites AS ps ON ps.project_id = p.id AND ps.site_id = #{@site.id}
          #{filtered_organizations_where}
          ORDER BY title
        SQL
        @organizations = Organization.find_by_sql(sql)

        sql = <<-SQL
          SELECT DISTINCT d.id, d.name AS title
          FROM donors AS d
          INNER JOIN projects AS p ON (p.end_date is NULL OR p.end_date > now()) #{q_filter}
          INNER JOIN projects_sites AS ps ON ps.project_id = p.id AND ps.site_id = #{@site.id}
          INNER JOIN donations AS dn ON dn.donor_id = d.id AND dn.project_id = p.id
          #{filtered_donors_where}
          ORDER BY title
        SQL
        @donors = Donor.find_by_sql(sql)

      end
      format.js do
        render :update do |page|
          page << "$('#search_view_more').html('#{escape_javascript(render(:partial => 'search/pagination'))}');"
          page << "$('#search_results').html('#{escape_javascript(render(:partial => 'search/projects'))}');"
          page << "IOM.ajax_pagination();"
          page << "resizeColumn();"
        end
      end
    end
  end

end
