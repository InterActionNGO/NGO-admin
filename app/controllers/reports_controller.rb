class ReportsController < ApplicationController

  layout 'report_layout'
  
	def index
		respond_to do |format|
			format.html do
				render :html => '/reports/index'
			end
		end
	end

	def report
		@data = Project.report(params)
		@data_json = @data.to_json

		respond_to do |format|
			format.html do
				render :html => '/reports/index'
			end
			# format.pdf do
			# 	render :pdf => 'reports/report'
			# end
		end
	end

end