class Admin::SitesController < Admin::AdminController

  def index
    @sites = Site.includes(:geographic_context_country).order('created_at DESC').paginate :per_page => 20, :page => params[:page]
  end

  def new
    @site = Site.new
  end

  def create
    @site = Site.new(params[:site])
    if @site.save
      flash[:notice] = 'Site created successfully.'
      redirect_to customization_admin_site_path(@site), :flash => {:success => 'Site has been created successfully'}
    else
      render :action => 'new'
    end
  end

  def projects
    @site = Site.find(params[:id])
    @projects = Project.
                select("projects.*").
                from("projects, projects_sites").
                where("projects_sites.site_id = #{@site.id} and projects_sites.project_id = projects.id").
                order('projects.name asc, created_at DESC').
                paginate :per_page => 10, :page => params[:page]
  end

  def edit
    @site = Site.find(params[:id])
  end

  def customization
    @site = Site.find(params[:id])
    @layers = Layer.where({:status => true})
    @layer_styles = LayerStyle.all
    render :action => 'edit'
  end

  def update
    @layers = params[:site][:layers_ids]
    params[:site].delete :layers_ids
    @site = Site.find(params[:id])
    @site.attributes = params[:site]
    if params[:site] && params[:site][:show_blog] == '0'
      @site.blog_url = nil
    end
    if @site.save
      flash[:notice] = 'Site updated successfully.'
      if params[:customization]
        @site.clean_layers
        self.add_layers(@layers) if !@layers.blank?
        redirect_to customization_admin_site_path(@site), :flash => {:success => 'Site has been updated successfully'}
      else
        redirect_to edit_admin_site_path(@site), :flash => {:success => 'Site has been updated successfully'}
      end
    else
      render :action => 'edit'
    end
  end

  def toggle_status
    @site = Site.find(params[:id])
    @site.status = !@site.status
    if @site.save
      respond_to do |format|
        format.html do
          redirect_to edit_admin_site_path(@site), :flash => {:success => 'Site has been updated successfully'}
        end
        format.js do
          render :update do |page|
            page << "$('#site_#{@site.id}').html('#{escape_javascript(render(:inline => "<%= link_to((@site.published? ? 'Published' : 'Not published'), toggle_status_admin_site_path(@site), :method => :post,:remote => true,:class => (@site.published? ? 'published' : 'not_published')) %>"))}');"
          end
        end
      end
    end
  end

  def destroy_aid_map_image
    @site = Site.find(params[:id])
    @site.aid_map_image.clear
    @site.save
    respond_to do |format|
      format.html do
        redirect_to customization_admin_site_path(@site), :flash => {:success => 'Site aid map image has been removed successfully'}
      end
    end
  end

  def destroy_logo
    @site = Site.find(params[:id])
    @site.logo.clear
    @site.save
    respond_to do |format|
      format.html do
        redirect_to customization_admin_site_path(@site), :flash => {:success => 'Site logo has been removed successfully'}
      end
    end
  end

  def destroy
    @site = Site.find(params[:id])
    @site.destroy
    redirect_to admin_sites_path, :flash => {:success => 'Site has been deleted successfully'}
  end

  def add_layers(value)
    value.each do |v|
      @l = v.split('#')
      @sl = SiteLayer.new
      @sl.site = @site
      @sl.layer = Layer.find(@l[0])
      @sl.layer_style = LayerStyle.find(@l[1])
      @sl.save
    end
  end
end
