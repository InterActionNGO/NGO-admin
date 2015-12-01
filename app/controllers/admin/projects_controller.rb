class Admin::ProjectsController < Admin::AdminController

  before_filter :count_projects
  before_filter :get_organizations_list

  def index
    @total_projects_count = current_user.admin?? Project.count : current_user.organization.projects.count
    @conditions = {}

    if params[:q]
      q = "%#{params[:q].sanitize_sql!}%"
      projects = find_projects(["name ilike ? OR description ilike ? OR intervention_id ilike ? OR organization_id ilike ?", q, q, q, q])
      from = ["projects"]
      unless params[:status].blank?
        if params[:status] == 'active'
          @conditions['active'] = {'status' => 'active'}
          projects = projects.where("end_date > ?", Date.today.to_s(:db))
        elsif params[:status] == 'closed'
          @conditions['closed'] = {'status' => 'closed'}
          projects = projects.where("end_date < ?", Date.today.to_s(:db))
        end
      end
      unless params[:country].blank? || params[:country] == "0"
        if country = Geolocation.find_by_id(params[:country])
          @conditions[country.name] = {'country' => params[:country]}
          from << 'geolocations_projects'
          projects = projects.from(from.join(',')).where("geolocations_projects.geolocation_id = #{country.id} AND geolocations_projects.project_id = projects.id")
        end
      end
      unless params[:cluster].blank? || params[:cluster] == '0'
        if cluster = Cluster.find_by_id(params[:cluster])
          @conditions[cluster.name] = {'cluster' => params[:cluster]}
          from << 'clusters_projects'
          projects = projects.from(from.join(',')).where("clusters_projects.cluster_id = #{cluster.id} AND clusters_projects.project_id = projects.id")
        end
      end
      unless params[:sector].blank? || params[:sector] == '0'
        if sector = Sector.find_by_id(params[:sector])
          @conditions[sector.name] = {'sector' => params[:sector]}
          from << 'projects_sectors'
          projects = projects.from(from.join(',')).where("projects_sectors.sector_id = #{sector.id} AND projects_sectors.project_id = projects.id")
        end
      end
      unless params[:site].blank? || params[:site] == '0'
        if site = Site.find(params[:site])
          @conditions[site.name] = {'site' => params[:site]}
          from << 'projects_sites'
          projects = projects.from(from.join(',')).where("projects_sites.site_id = #{site.id} AND projects_sites.project_id = projects.id")
        end
      end
      unless params[:organization].blank? || params[:organization] == '0'
        if org = Organization.find(params[:organization])
          @conditions[org.name] = {'organization' => params[:organization]}
          projects = projects.where("primary_organization_id = #{params[:organization]}")
        end
      end
      @projects = projects.paginate :per_page => 20, :order => 'name asc', :page => params[:page]
    elsif params[:organization_id]
      template      = 'admin/organizations/projects'
      @organization = current_user.admin?? Organization.find(params[:organization_id]) : current_user.organization
      projects      = @organization.projects
      @projects     = projects.paginate :per_page => 20, :order => 'name asc', :page => params[:page]
    else
      @projects = find_projects.paginate :per_page => 20, :order => 'name asc', :page => params[:page]
    end

    respond_to do |format|
      format.html do
        render :template => template if template.present?
      end
      format.csv do
        if projects.present?
          filename = if @organization
            "#{@organization.name}_projects.csv"
          else
            "projects.csv"
          end
          send_data projects.serialize_to_csv(:headers => Project.csv_attributes),
            :type => 'application/download; application/vnd.ms-excel; text/csv; charset=iso-8859-1; header=present',
            :disposition => "attachment; filename=#{filename}"
        end
      end
    end
  end

  def new
    @project = new_project(:date_provided => Time.now)

    if Rails.env.development?
      @project.start_date  = Time.now
      @project.end_date    = 10.years.since
    end

    @organizations_ids   = organizations_ids
    @countries_iso_codes = countries_iso_codes
  end

  def create
    @project = new_project(params[:project])
    @project.intervention_id = nil
    @project.updated_by = current_user
    if @project.save
      flash[:notice] = "Project created! Now you can <a href='#{donations_admin_project_path(@project)}'>provide the donor information</a> for this project."
      redirect_to edit_admin_project_path(@project), :flash => {:success => 'Project has been created successfully'}
    else
      @organizations_ids   = organizations_ids
      @countries_iso_codes = countries_iso_codes
      @countries = @project.country_ids.map{|id| Country.find(id)}
      @regions = @project.region_ids.map{|id| Region.find(id)}
      render :action => 'new'
    end
  end

  def donations
    @project = find_project(params[:id])
  end

  def edit
    @project              = find_project(params[:id])
    @project.date_updated = Time.now
    @organizations_ids   = organizations_ids
    @countries_iso_codes = countries_iso_codes
  end

  def update
    @project = find_project(params[:id])
    @sectors = @project.sectors
    @project.attributes = params[:project]
    @project.updated_by = current_user
    if params[:project][:sector_ids].nil? && !@project.sectors.empty?
        @organizations_ids   = organizations_ids
        @countries_iso_codes = countries_iso_codes
        @project.sectors = @sectors
        flash.now[:error] = 'Sorry, you can\'t remove all sectors'
        render :action => 'edit'
    else
      if @project.save
        @project.update_data_denormalization
        flash[:notice] = 'Project updated successfully.'
        redirect_to edit_admin_project_path(@project), :flash => {:success => 'Project has been updated successfully'}
      else
        @organizations_ids   = organizations_ids
        @countries_iso_codes = countries_iso_codes
        flash.now[:error] = 'Sorry, there are some errors that must be corrected.'
        render :action => 'edit'
      end
    end
  end

  def destroy
    redirect_to root_path unless current_user.present? && current_user.admin?

    @project = find_project(params[:id])
    @project.destroy
    redirect_to admin_projects_path, :flash => {:success => 'Project has been deleted successfully'}
  end

  def count_projects
    @projects_count = if current_user.admin?
      Project.count
    else
      current_user.organization.projects.count
    end
  end
  private :count_projects

  def new_project(attributes = {})
    if current_user.admin?
      Project.new(attributes)
    else
      current_user.organization.projects.new(attributes)
    end
  end
  private :new_project

  def find_project(id)
    if current_user.admin?
      @project = Project.find(params[:id])
    else
      @project = current_user.organization.projects.find(params[:id])
    end
  end
  private :find_project


  def find_projects(where = nil)
    if current_user.admin?
      projects = Project.scoped
    else
      projects = current_user.organization.projects
    end
    projects = projects.where(where) if where.present?
    projects || []
  end
  private :find_projects

  def get_organizations_list
    @organizations_list = if current_user.admin?
      Organization.get_select_values
    else
      [current_user.organization]
    end
    @organizations_list
  end
  private :get_organizations_list

  def organizations_ids
    Hash[Organization.select([:id, :organization_id]).all.map{|o| [o.id, o.organization_id]}]
  end
  private :organizations_ids

  def countries_iso_codes
    Hash[Geolocation.select([:id, :country_code]).where(:adm_level => 0).map{|o| [o.id, o.country_code]}]
  end
  private :countries_iso_codes

end
