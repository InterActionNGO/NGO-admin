class Admin::ProjectsSynchronizationsController < Admin::AdminController

  layout false

  def create
    synchronization = ProjectsSynchronization.new(:projects_file => params[:qqfile])
    synchronization.user = current_user
    begin
      synchronization.save
    rescue => e
      Rails.logger.error("[ProjectsSynchronization ERROR FOR save]")
      Rails.logger.error e
      Rails.logger.error e.backtrace.join("\n")
    end

    if synchronization.projects_errors.present?
      Rails.logger.error("[PROJECT ERRORS FOR BATCH IMPORT] #{synchronization.projects_errors.inspect}")
    end

    respond_to do |format|
      format.html {
        render :json => synchronization, :content_type => 'text/html', :layout => false
      }
      format.json {
        render :json => synchronization
      }
    end
  end

  def update
    synchronization = ProjectsSynchronization.find(params[:id])
    synchronization.user = current_user
    synchronization.save

    render :json => synchronization
  end

end
