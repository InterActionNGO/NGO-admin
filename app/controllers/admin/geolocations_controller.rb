class Admin::GeolocationsController < Admin::AdminController
    
    before_filter :login_required
#     before_filter :redirect_unauthorized
    
    def index
        respond_to do |format|
            
            format.html do
                geolocations = Geolocation.scoped
                @conditions = {}
            
                if params[:q]
                    unless params[:q].blank?
                        q = "%#{params[:q].sanitize_sql!}%"
                        geolocations = geolocations.where("name ilike ? or country_name ilike ?", q, q)
                        @conditions['Text Contains'] = q[1..-2]
                    end
                    unless params[:country].blank?
                        geolocations = geolocations.where(:country_name => params[:country])
                        @conditions['Country'] = params[:country]
                    end
                    unless params[:level].blank?
                        geolocations = geolocations.where(:adm_level => params[:level])
                        @conditions['Admin Level'] = params[:level]
                    end
                    unless params[:source].blank?
                        geolocations = geolocations.where(:provider => params[:source])
                        @conditions['Source'] = params[:source]
                    end
                end
                @geolocations = geolocations.order('country_name, name').paginate :per_page => 50, :page => params[:page]
                @geolocations_query_total = geolocations.count
            end
            format.json do
                level = params[:level] if params[:level].present?
                geolocation = params[:geolocation]
                @geolocations = Geolocation.fetch_all(level, geolocation)
                render :json => @geolocations.to_json
            end
        end
    end
    
    def new
       @geolocation = Geolocation.new 
    end
    
    def create
       @geolocation = Geolocation.new(geolocation_params)
       if @geolocation.save
           flash[:notice] = 'Geolocation created successfully.'
           redirect_to edit_admin_geolocation_path(@geolocation)
       else
           flash[:error] = @geolocation.errors.full_messages
           render :action => 'new'
       end
    end
    
    def edit 
        @geolocation = Geolocation.find(params[:id])
        @current_user = current_user
    end
    
    def update
        @geolocation = Geolocation.find(params[:id])
        @geolocation.attributes = geolocation_params
        if @geolocation.save
            flash[:notice] = 'Geolocation updated successfully.'
            redirect_to edit_admin_geolocation_path(@geolocation)
        else
            flash.now[:error] = @geolocation.errors.full_messages
            render :action => 'edit'
        end
    end
    
    def destroy
        @geolocation = Geolocation.find(params[:id])
        if @geolocation.destroy
            flash[:notice] = 'Geolocation deleted successfully.'
            redirect_to admin_geolocations_path
        else
            flash.now[:error] = @geolocation.errors.full_messages
            render :action => 'edit'
        end
    end
    
    def reassign
        current_geo = Geolocation.find(params[:geolocation_id])
        new_geo = Geolocation.find(params[:reassign_to]) || nil
        if !new_geo.nil?
            if current_geo.reassign_projects(new_geo).eql?(false)
                flash.now[:error] = 'Error reassigning projects.'
                render :controller => :projects, :action => :index
            else
               flash[:notice] = 'Projects reassigned successfully.'
               redirect_to edit_admin_geolocation_path(current_geo)
            end
        else
            flash.now[:error] = 'Could not find Geolocation with provided ID'
            render :controller => :projects, :action => :index
        end
    end
    
    private
    def geolocation_params
        params.require(:geolocation).permit(:name,:country_name,:country_code,:adm_level,:provider,:custom_geo_source,:g0,:g1,:g2,:g3,:g4,:uid,:country_uid,:latitude,:longitude,:fclass,:fcode,:cc2,:admin1,:admin2,:admin3,:admin4)
    end
end
