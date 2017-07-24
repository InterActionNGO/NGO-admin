module Admin::ProjectsHelper

    def organizations_list(for_reporting_orgs = false)
        
        if for_reporting_orgs.eql?(false) || @admin
            
            Rails.cache.fetch("/organizations/#{Organization.max_updated_at}-#{Organization.all.size}/organizations_list_json", :expires_in => 12.hours) do
                Organization.order(:name).all.map { |o| { :id => o.id, :text => o.name }}.unshift({:id => '', :text => '' }).to_json
            end
        else
            [{:id => @user_org.id, :text => @user_org.name}].to_json
        end
        
    end
    
    def format_date(attr)
       if attr.present?
           attr.strftime("%Y-%m-%d")
       else
           nil
       end
    end
    
    def select_box_options(field = nil)
        if @project.new_record? || action_name == 'donations'
            []
        elsif field.nil? || field == :reporting_organization
            [[@project.primary_organization.name,@project.primary_organization_id]]
        elsif field == :prime_awardee && !@project.prime_awardee.nil?
            [[@project.prime_awardee.name, @project.prime_awardee_id]]
        elsif field == :partners && @project.partners.size > 0
            partners = []
            @project.partners.each do |p|
               partners << [p.name, p.id] 
            end
            partners
        else
            []
        end
    end
    
    def get_currency_list
       
        Rails.cache.fetch("currency_select_options", :expires_in => 7.days) do
            Money::Currency.table.values.map{|c| ["#{c[:name]} (#{c[:iso_code]})", c[:iso_code]] }.sort_by{|o| o.first }
        end
    end
    
end
