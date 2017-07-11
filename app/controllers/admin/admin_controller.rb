class Admin::AdminController < ApplicationController
    
  before_filter :login_required
  before_filter :check_user_permissions

  def index
    @changes_last_day_count = ChangesHistoryRecord.in_last_24h.count
    @changes_count          = ChangesHistoryRecord.count

    unless current_user.administrator?
      @organization = organization = current_user.organization

      @organization_data = OpenStruct.new( {
        :name                  => organization.try(:name),
        :active_projects_count => organization.projects.active.count,
        :closed_projects_count => organization.projects.closed.count,
        :website               => organization.website,
        :contact_information   => [organization.hq_address,
                                   organization.hq_address2,
                                   organization.contact_city,
                                   organization.contact_zip,
                                   organization.contact_state
                                  ],
        :logo                  => organization.logo.url(:small)
      } )

      @organization_sites = organization.sites.map do |site|
        active_projects_count = site.projects_for_organization(organization).active.count
        closed_projects_count = site.projects_for_organization(organization).closed.count

        next if active_projects_count == 0 && closed_projects_count == 0

        attributes_for_site = OpenStruct.new organization.attributes_for_site(site)
        attributes          = OpenStruct.new organization.attributes

        OpenStruct.new(
          :site_id               => site.id,
          :name                  => site.name,
          :internal_description  => site.internal_description,
          :active_projects_count => active_projects_count,
          :closed_projects_count => closed_projects_count,
          :donation_information  => [attributes.donation_address,
                                    attributes.donation_address2,
                                    [attributes.zip_code,
                                    attributes.city,
                                    attributes.state].join(', '),
                                    attributes.donation_country,
                                    attributes.donation_phone_number,
                                   "<a href='#{attributes.donation_website}'>#{attributes.donation_website}</a>"
                                   ],
          :data_contact_information => [attributes_for_site.main_data_contact_name || attributes.main_data_contact_name,
                                        attributes_for_site.main_data_contact_position || attributes.main_data_contact_position,
                                        attributes_for_site.main_data_contact_phone_number || attributes.main_data_contact_phone_number,
                                        "<a href='#{attributes_for_site.main_data_contact_email}'>#{attributes_for_site.main_data_contact_email}</a>".presence || "<a href='#{attributes.main_data_contact_email}'>#{attributes.main_data_contact_email}</a>"
                                       ]
        )
      end

    end
  end
  # Fix this method!  Specifically the Project.to_csv method...
  def export_projects
    options = {
      :include_non_active =>true
    }
    options[:organization]    = params[:organization_id] if params[:organization_id].present?
    options[:organization]    = current_user.organization_id unless current_user.admin?
    options[:headers_options] = {:show_private_fields => true}

    respond_to do |format|
      format.html do
        render :text => Project.to_csv(nil, options)
      end
      format.csv do
        send_data Project.to_csv(nil, options),
          :type => 'text/csv; charset=utf-8; application/download',
          :disposition => "attachment; filename=ngoaidmap_projects.csv"
      end
      format.xls do
        send_data Project.to_excel(nil, options),
          :type => 'application/vnd.ms-excel',
          :disposition => "attachment; filename=ngoaidmap_projects.xls"
      end
    end
  end

  def export_organizations
    respond_to do |format|
      format.csv do
         send_data Organization.to_csv,
                 :filename => "ngoaidmap_organizations.csv",
                 :type =>  'text/csv; charset=utf-8; application/download'
      end
    end
  end

  def check_user_permissions
    unless current_user.admin?
      redirect_to admin_admin_path unless
        controller_name == 'projects' ||
        (controller_name == 'organizations' && ['specific_information','destroy_logo','edit','update'].include?(action_name)) ||
        (controller_name == 'geolocations' && action_name == 'index' && request.format.json?) ||
        (controller_name == 'admin' &&
            (action_name == 'export_projects' || action_name == 'index')) ||
        (controller_name == 'donations' &&
            (['create','destroy'].include?(action_name))) ||
        controller_name == 'media_resources'
        controller_name == 'resources'
    end
  end
  private :check_user_permissions
  
  
end
