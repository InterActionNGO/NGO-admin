class Admin::OfficesController < Admin::AdminController
  before_filter :get_donor, :only => :index

  def index
    @offices = if @donor.present?
                  offices = @donor.offices.order('offices.name asc')

                  if params[:q].present?
                    q = "%#{params[:q].sanitize_sql!}%"
                    offices = offices.where(["offices.name ilike ?", q])
                  end
                  offices
                else
                  offices = Office
                  if params[:q].present? || params[:filter_donor_id].present?
                    if params[:filter_donor_id].present?
                      offices = offices.where(["organization_id =?", params[:filter_donor_id]])
                      @donor_filter = Organization.find(params[:filter_donor_id])
                    end
                    if params[:q].present?
                      q = "%#{params[:q].sanitize_sql!}%"
                      offices = offices.where(["offices.name ilike ?", q])
                    end
                  end
                  offices
                end

    @offices = @offices.joins(:donor).order('offices.name asc').all
    @offices = @offices.order('created_at DESC').paginate :per_page => 20,
                                                     :page => params[:page]
    @donors = [['All', nil]] + Organization.with_donations.uniq.order('name').map{|d| [d.name, d.id]}

    respond_to do |format|
      format.html
      format.json do
        render :json => @offices.first(5).map{ |office| {:value => office.name.html_safe, :label => office.name.html_safe.truncate(40), :element_id => office.id} }.to_json
      end
    end
  end

  def new
    @office = Office.new(:donor_id => params[:donor_id])
    @donors = Organization.with_donations.uniq.map{|d| [d.name, d.id]}.sort{|a, b| a[0] <=> b[0]}
  end

  def create
    @office = Office.new(params[:office])
    if @office.save
      flash[:notice] = 'Office created successfully.'
      redirect_to admin_offices_path, :flash => {:success => 'Office created successfully.'}
    else
      render :action => 'new'
    end
  end

  def projects
    @office = Office.find(params[:id])
  end

  def edit
    @office = Office.find(params[:id])
    @donors = Organization.with_donations.uniq.map{|d| [d.name, d.id]}
  end

  def update
    @office = Office.find(params[:id])
    @office.attributes = params[:office]
    if @office.save
      flash[:notice] = 'Office updated successfully.'
      redirect_to edit_admin_office_path(@office), :flash => {:success => 'Office updated successfully.'}
    else
      render :action => 'edit'
    end
  end

  def destroy
    @office = Office.find(params[:id])
    @office.destroy
    redirect_to admin_offices_path, :flash => {:success => 'Office deleted successfully'}
  end

  private

  def get_donor
    @donor = Organization.find(params[:donor_id]) if params[:donor_id]
  end
end
