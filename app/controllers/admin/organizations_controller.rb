class Admin::OrganizationsController < Admin::AdminController

  def index
    
    organizations = Organization
    @conditions = {}
    
    if params[:q]
        unless params[:q].blank?
            q1 = params[:q].sanitize_sql!
            q2 = "%#{q1}%"
            qstring = "name ilike ? or description ilike ? or acronym ilike ?"
            where_array = [q2]*3
            if params[:fuzzy_search]
                qstring += " or similarity(name, ?) > 0.3" 
                where_array << q1
            end
            where_array.unshift(qstring)
            organizations = Organization.where(where_array)
            @conditions['find text'] = q1
            @conditions['approximate search'] = params[:fuzzy_search] ? 'Yes' : 'No'
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
    @organization = get_organization
    @site = Site.find(params[:site_id])
    @organization.attributes = @organization.attributes_for_site(@site)
  end

  def edit
      if user_can_edit_org?
          @organization = Organization.find(params[:id])
      else
          redirect_to edit_admin_organization_path(current_user.organization)
      end
          
  end

  def update
    @organization = get_organization
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
    @organization = get_organization
    @organization.destroy
    redirect_to admin_organizations_path, :flash => {:success => 'Organization has been deleted successfully'}
  end

  def destroy_logo
    @organization = get_organization
    @organization.logo.clear
    @organization.save
    respond_to do |format|
      format.html do
        redirect_to edit_admin_organization_path(@organization), :flash => {:success => 'Organization logo has been removed successfully'}
      end
    end
  end
  
  private
  def get_organization
      if current_user.admin?
          Organization.find(params[:id])
      else
          current_user.organization
      end
  end
  
  def user_can_edit_org?
      current_user.admin? || current_user.organization.id.to_s == params[:id]
  end
  
end
