class Admin::DonationsController < Admin::AdminController

    layout 'admin_projects_layout'
  def create
    @project = Project.find(params[:project_id])
#     donor = Organization.where(:id => params[:donation][:donor_id]).first
#     office = Office.where(:id => params[:donation][:office_id]).first
#     @donation = Donation.new(params[:donation].slice!(:donor_id, :office_id))
#     dne
    @donation = Donation.new(params[:donation])
#     if donor.present?
#       @donation.donor = donor
#       @donation.office = office if office.present?
#     end
#     @donation.office = nil unless @donation.office && @donation.office.valid?
#     @donation.office.donor = @donation.donor if @donation.office.present? && @donation.office.donor.blank?
    if @donation.save
#         @project.donations << @donation
        @project.update_attributes({:updated_by => current_user, :skip_callbacks => true})

#         if @project.save
#         redirect_to donations_admin_project_path(@project), :flash => {:success => 'Donation has been created successfully'}
#         else
#         render :template => 'admin/projects/donations'
#         end
        flash[:success] = 'Donation created successfully!'
        redirect_to donations_admin_project_path(@project)
    else
        flash.now[:error] = @donation.errors.full_messages
        render 'admin/projects/donations'
    end
  end

  def destroy
    @project = Project.find(params[:project_id])
    @donation = Donation.find(params[:id])
    if @donation.destroy
#         @project.donations.delete(@donation)
#         @project.update_column(:updated_by, current_user)
        @project.update_attributes({:updated_by => current_user, :skip_callbacks => true})
        flash[:success] = 'Donation deleted successfully'
        redirect_to donations_admin_project_path(@project)
    else
        flash.now[:error] = 'Error deleting donation'
        render 'admin/projects/donations'
    end

#     redirect_to donations_admin_project_path(@project), :flash => {:success => 'Donation has been deleted successfully'}
  end

end
