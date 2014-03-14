module DonorsHelper

  def donors_list_subtitle
    by = "FUNDED BY #{@donor.name}"
    if @filter_by_location && @filter_by_category && @filter_by_organization
      pluralize(@projects_count, "#{@category_name} PROJECT", "#{@category_name} PROJECTS") + ' ' + by + " implemented  by #{@organization.name}" + " in #{@location_name}"
    elsif @filter_by_location && @filter_by_category
      pluralize(@projects_count, "#{@category_name} PROJECT", "#{@category_name} PROJECTS") + ' ' + by + " in #{@location_name}"
    elsif @filter_by_location
      pluralize(@projects_count, "PROJECT", "PROJECTS") + ' ' + by + " in #{@location_name}"
    elsif @filter_by_category
      pluralize(@projects_count, "#{@filter_name} PROJECT", "#{@filter_name} PROJECTS") + ' ' + by
    else
      pluralize(@projects_count, "PROJECT", "PROJECTS") + ' ' + by
    end
  end

end
