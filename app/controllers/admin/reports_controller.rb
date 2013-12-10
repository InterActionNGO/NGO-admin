class Admin::ReportsController < Admin::AdminController

	def index
		respond_to do |format|
			format.html do
				render :html => '/admin/report/index'
			end
		end
	end

	def report
		start_date = Date.parse(params[:start_date]['day']+"-"+params[:start_date]['month']+"-"+params[:start_date]['year'])
		end_date = Date.parse(params[:end_date]['day']+"-"+params[:end_date]['month']+"-"+params[:end_date]['year'])
		countries = donors = sectors = organizations = []
		countries = params[:country] if params[:country]
		donors = params[:donor] if params[:donor]
		sectors = params[:sector] if params[:sector]
		organizations = params[:organization] if params[:organization]

		@projects_start = Project.start_date_gt(start_date)
		@projects_start = @projects_start.countries_name_in(countries) if ( params[:country] && !params[:country].include?('All') )
		@projects_start = @projects_start.primary_organization_name_in(organizations) if ( params[:organization] && !params[:organization].include?('All') )
		@projects_start = @projects_start.donors_name_in(donors) if ( params[:donor] && !params[:donor].include?('All') )
		@projects_start = @projects_start.sectors_name_in(sectors) if ( params[:sector] && !params[:sector].include?('All') )

		@projects_end = Project.end_date_lt(start_date)
		@projects_end = @projects_end.countries_name_in(countries)  if ( params[:country] && !params[:country].include?('All') )
		@projects_end = @projects_end.primary_organization_name_in(organizations) if ( params[:organization] && !params[:organization].include?('All') )
		@projects_end = @projects_end.donors_name_in(donors)  if ( params[:donor] && !params[:donor].include?('All') )
		@projects_end = @projects_end.sectors_name_in(sectors)  if ( params[:sector] && !params[:sector].include?('All') )

		@projects = (@projects_start + @projects_end).uniq

		respond_to do |format|
			format.pdf do
				render :pdf => 'admin/reports/report'
			end
		end
	end

end