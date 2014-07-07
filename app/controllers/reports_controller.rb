require 'json'

class ReportsController < ApplicationController

  layout 'site_layout'

	def index
		respond_to do |format|
			format.html do
				#render :html => '/reports/index'
				@org_combo_values = [['All','All']] + Organization.get_select_values.collect{ |o| [o.name, o.name] }
				@countries_combo_values = [['All','All']] + Country.get_select_values.collect{ |c| [c.name, c.name] }
				@sectors_combo_values = [['Any sector','All']] + Sector.get_select_values.collect { |c| [c.name, c.name] }
				@donors_combo_values = [['Any donor','All']] + Donor.get_select_values.collect{ |d| [d.name, d.name] }
				@date_start = Date.new(2005, 1, 1)
				@date_end = Date.today
			end
		end
    params[:id] = 'report'
	end

	def report
		@data = Project.report(params)
    @data = Project.bar_chart_report(params)

		#@data_json = @data.to_json

		respond_to do |format|
			format.html

      format.json { render :json => @data }
      #format.json { render :json => @data[:results].collect{|x| JSON.generate(x) }}
      #format.json { render :json => JSON.generate(@data) }
			# format.pdf do
			# 	render :pdf => 'reports/report'
			# end
		end
	end

  def filter_by_indicator
    indicator = params[:indicator_name]
    operator = params[:operator]
    value = params[:indicator_value]

  end

  def get_table
    #@table = Organization.select('organizations.id,organizations.name').joins(:projects).where('end_date > ?', Time.now).select('projects.id,projects.name').group('organizations.id,organizations.name, projects.id,projects.name').limit(10)
    @table = Organization.joins(:projects).group('organizations.name').count('projects.id').sort_by {|k,v| v}.reverse
    respond_to do |format|
      format.json { render :json => {'organizations' => @table.to_json} }
    end
  end


end
