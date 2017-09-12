class Admin::HumanitarianScopesController < Admin::AdminController
  before_filter :set_project
  before_filter :ensure_humanitarian_project, :only => :create

  def index
    @humanitarian_scope = HumanitarianScope.new
  end

  def create
    @humanitarian_scope = @project.humanitarian_scopes.new(params[:humanitarian_scope])

    if @humanitarian_scope.save
      redirect_to admin_project_humanitarian_scopes_url(@project),
        :notice => "Humanitarian scope has been created successfully"
    else
      render :index
    end
  end

  def destroy
    humanitarian_scope = @project.humanitarian_scopes.find(params[:id])

    if humanitarian_scope.destroy
      message = "Humanitarian scope has been deleted successfully"
    else
      message = "Something went wrong"
    end

    redirect_to admin_project_humanitarian_scopes_url(@project), :notice => message
  end

  private

  def set_project
    @project ||= Project.find(params[:project_id])
  end

  def ensure_humanitarian_project
    unless @project.humanitarian?
      redirect_to admin_project_humanitarian_scopes_url(@project),
        :notice => "Project must be flagged humanitarian before creating scope"
    end
  end

  def type_options
    HumanitarianScopeType.order(:name).map { |t| [t.name, t.id] }.unshift("")
  end
  helper_method :type_options

  def vocabulary_options
    HumanitarianScopeVocabulary.order(:name).map { |t| [t.name, t.id] }.unshift("")
  end
  helper_method :vocabulary_options

end
