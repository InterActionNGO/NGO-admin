class Admin::ProjectsController < Admin::AdminController

  before_filter :count_projects
  before_filter :get_organizations_list

  def index
    @conditions = {}

    if params[:q]
      if params[:q].blank?
          projects = find_projects
      else
        q = "%#{params[:q].sanitize_sql!}%"
        projects = find_projects(["projects.name ilike ? OR projects.description ilike ? OR projects.intervention_id ilike ? OR projects.organization_id ilike ?", q, q, q, q])
        @conditions['find text'] = q[1..-2]
      end
      unless params[:status].blank? || params[:status] == "0"
        if params[:status] == 'active'
          projects = projects.active
        elsif params[:status] == 'closed'
          projects = projects.closed
        end
        @conditions['status'] = params[:status]
      end
      unless params[:country].blank? || params[:country] == "0"
        if country = Geolocation.where('country_code = ?', params[:country]).first
            @conditions['country'] = country.country_name
            projects = projects.where("geolocations.country_code = ?", params[:country])
        end
      end
      unless params[:sector].blank? || params[:sector] == '0'
        if sector = Sector.find_by_id(params[:sector])
          @conditions['sector'] = sector.name
          projects = projects.where("sectors.id = #{sector.id}")
        end
      end
      unless params[:site].blank? || params[:site] == '0'
        if site = Site.find(params[:site])
          @conditions['site'] = site.name
          projects = projects.includes(:sites).where("sites.id = #{site.id}")
        end
      end
      unless params[:organization].blank? || params[:organization] == '0'
        if (org = Organization.find(params[:organization])) && current_user.admin?
          @conditions['organization'] = org.name
          projects = projects.where("primary_organization_id = #{params[:organization]}")
        end
      end
      @projects_query_total = projects.size
      @projects = projects.order('projects.name asc').paginate :per_page => 20, :page => params[:page]
    elsif params[:organization_id]
      template      = 'admin/organizations/projects'
      @organization = current_user.admin?? Organization.find(params[:organization_id]) : current_user.organization
      projects      = @organization.projects.includes(:donors, :sectors, :geolocations, :partners)
      @projects_query_total = projects.size
      @projects     = projects.order('name asc').paginate :per_page => 20, :page => params[:page]
    elsif params[:tag_id]
      template      = 'admin/tags/projects'
      @tag = Tag.find(params[:tag_id])
      projects      = @tag.projects
      @projects     = projects.order('name asc').paginate :per_page => 20, :page => params[:page]
    else
      @projects_query_total = @projects_count
      @projects = find_projects.order('name asc').paginate :per_page => 20, :page => params[:page]
    end

    respond_to do |format|
      format.html do
        render :template => template if template.present?
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
    associations = [:geolocations, :sectors]
    if current_user.admin?
      projects = Project.scoped
      associations << :primary_organization
    else
      projects = current_user.organization.projects
    end
    projects = projects.where(where) if where.present?
    projects.includes(associations) || []
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
