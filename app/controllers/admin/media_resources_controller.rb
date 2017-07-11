class Admin::MediaResourcesController < Admin::AdminController

  before_filter :set_element

  def index
    @resource = @element.media_resources.new
  end

  def create
    @resource = @element.media_resources.new(params[:media_resource])
    @resource.element = @element
    if @resource.save
      redirect_to eval("admin_#{@element.class.name.singularize.downcase}_media_resources_path(@element)"), :flash => {:success => 'Resource has been created successfully'}
    else
      render :action => 'index'
    end
  end

  def update
    @resource = @element.media_resources.find(params[:id])
    @resource.attributes = params[:media_resource]
    if params[:up]
      @resource.move_up
    end
    if params[:down]
      @resource.move_down
    end
    if @resource.save
      redirect_to eval("admin_#{@element.class.name.singularize.downcase}_media_resources_path(@element)"), :flash => {:success => 'Resource has been updated successfully'}
    else
      render :action => 'index'
    end
  end

  def destroy
    @resource = @element.media_resources.find(params[:id])
    @resource.destroy
    redirect_to eval("admin_#{@element.class.name.singularize.downcase}_media_resources_path(@element)"), :flash => {:success => 'Resource has been destroyed successfully'}
  end

  private

    def set_element
      if params[:project_id]
        @element = @project = current_user.admin? ?
            Project.find(params[:project_id]) :
            current_user.organization.projects.find(params[:project_id])
      elsif params[:organization_id]
        @element = @organization = current_user.admin? ?
            Organization.find(params[:organization_id]) :
            current_user.organization
      elsif params[:site_id]
        @element = @site = Site.find(params[:site_id]) if current_user.admin?
      end
    end

end
