class Admin::DonationsController < Admin::AdminController

  before_filter :login_required

  def create
    @project = Project.find(params[:project_id])
    donor = Donor.where(:id => params[:donation][:donor_id]).first
    @donation = Donation.new(params[:donation].slice!(:donor_id))
    @donation.donor = donor if donor.present?
    @project.donations << @donation
    @project.updated_by = current_user

    if @project.save
      redirect_to donations_admin_project_path(@project), :flash => {:success => 'Donation has been created successfully'}
    else
      render :template => 'admin/projects/donations'
    end
  end

  def destroy
    @project = Project.find(params[:project_id])
    @donation = @project.donations.find(params[:id])
    @donation.destroy
    @project.donations.delete(@donation)
    @project.updated_by = current_user
    @project.save

    redirect_to donations_admin_project_path(@project), :flash => {:success => 'Donation has been deleted successfully'}
  end

end
