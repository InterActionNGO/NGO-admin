class Admin::OrganizationsController < ApplicationController

  before_filter :login_required

  def index
      
    redirect_to edit_admin_organization_path(current_user.organization) and return unless current_user.admin?
    
    organizations = Organization
    @conditions = {}
    
    if params[:q]
        unless params[:q].blank?
            q = "%#{params[:q].sanitize_sql!}%"
            organizations = Organization.where(["name ilike ? OR description ilike ? OR acronym ilike ?", q, q, q])
            @conditions['find text'] = q[1..-2]
        end
        
        unless params[:membership_status].blank?
            organizations = organizations.where(:membership_status => params[:membership_status])
            @conditions['Membership Status'] = params[:membership_status]
        end
        
        unless params[:organization_type].blank?
           organizations = organizations.where(:organization_type => params[:organization_type])
           @conditions['Organization_Type'] = params[:organization_type]
        end
        
        unless params[:international].blank?
           organizations = organizations.where(:international => params[:international])
           @conditions['Local/International'] = params[:international] ? 'International' : 'Local'
        end
        
        unless params[:publishing_to_iati].blank?
           organizations = organizations.where(:publishing_to_iati => params[:publishing_to_iati])
           @conditions['Publishing to IATI'] = params[:publishing_to_iati] ? 'Yes' : 'No'
        end
        
        unless params[:contact_country].blank?
           organizations = organizations.where(:contact_country => params[:contact_country])
           @conditions['HQ Country'] = params[:contact_country]
        end
    end

    @organizations_query_total = organizations.count
    @organizations = organizations.order('name asc, created_at DESC').paginate :per_page => 20, :page => params[:page]
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(params[:organization])
    @organization.updated_by = current_user
    if @organization.save
      flash[:notice] = 'Organization created successfully.'
      redirect_to edit_admin_organization_path(@organization), :flash => {:success => 'Organization has been created successfully'}
    else
      render :action => 'new'
    end
  end

  def specific_information
    @organization = Organization.find(params[:id])
    @site = Site.find(params[:site_id])
    @organization.attributes = @organization.attributes_for_site(@site)
  end

  def edit
     if !current_user.admin? && params[:id] != current_user.organization.id.to_s
         redirect_to edit_admin_organization_path(current_user.organization)
     else
        @organization = current_user.admin? ? Organization.find(params[:id]) : current_user.organization
     end
  end

  def update
    @organization = current_user.admin? ? Organization.find(params[:id]) : current_user.organization
    if params[:site_id]
      if @site = Site.find(params[:site_id])
        @organization.attributes_for_site = {:organization_values => params[:organization], :site_id => params[:site_id]}
      end
    else
      @organization.attributes = params[:organization]
    end
    @organization.updated_by = current_user
    if @organization.save
      flash[:notice] = 'Organization updated successfully.'
      @organization.update_data_denormalization
      if params[:site_id]
        redirect_to organization_site_specific_information_admin_organization_path(@organization, @site), :flash => {:success => 'Organization has been updated successfully'}
      else
        redirect_to edit_admin_organization_path(@organization), :flash => {:success => 'Organization has been updated successfully'}
      end
    else
      flash.now[:error] = @organization.errors.full_messages
      render :action => 'edit'
    end
  end

  def destroy
    @organization = Organization.find(params[:id])
    @organization.destroy
    redirect_to admin_organizations_path, :flash => {:success => 'Organization has been deleted successfully'}
  end

  def destroy_logo
    @organization = Organization.find(params[:id])
    @organization.logo.clear
    @organization.save
    respond_to do |format|
      format.html do
        redirect_to edit_admin_organization_path(@organization), :flash => {:success => 'Organization logo has been removed successfully'}
      end
    end
  end

end
