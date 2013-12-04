class Admin::ReportsController < Admin::AdminController
	
	def index
		respond_to do |format|
			format.html do
				render :html => '/admin/report/index'
			end
		end
	end

	def report
		respond_to do |format|
			format.pdf do
				render :pdf => 'admin/reports/report'
			end
		end
	end
end