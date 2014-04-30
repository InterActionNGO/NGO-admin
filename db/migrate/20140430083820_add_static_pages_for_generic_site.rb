class AddStaticPagesForGenericSite < ActiveRecord::Migration

  def self.up
    generic_site_id = Site.where(:name => "generic").select("id").first.id
    # PAGES FOR "DATA" MENU

    #Create top things page
    generic_top_site = Page.where(:permalink => "top-things-you-should-know-about-the-data").first.clone
    generic_top_site.created_at = generic_top_site.updated_at = nil
    generic_top_site.site_id=generic_site_id
    generic_top_site.save

    #Create member guidance page
    member_guidance = Page.where(:permalink => "member-guidance").first.clone
    member_guidance.title = "Data Guidance"
    member_guidance.permalink = "data-guidance"
    member_guidance.created_at = member_guidance.updated_at = nil
    member_guidance.site_id=generic_site_id
    member_guidance.save


    # PAGES FOR "About" MENU

    # Parent id
    about_parent_id = Page.where(:permalink => "about", :site_id => generic_site_id).first.id

    purpose = Page.new do |p|
      p.site_id = generic_site_id
      p.parent_id = about_parent_id
      p.title = "Purpose"
      p.permalink = "purpose"
      p.published = "TRUE"
      p.order_index = 1
    end
    purpose.save

    on_the_map = Page.new do |p|
      p.site_id = generic_site_id
      p.parent_id = about_parent_id
      p.title =  "Getting on the Map"
      p.permalink = "getting-on-the-map"
      p.published = "TRUE"
      p.order_index = 2
    end
    on_the_map.save

    staff_list = Page.new do |p|
      p.site_id = generic_site_id
      p.parent_id = about_parent_id
      p.title =  "Staff List"
      p.permalink = "staff-list"
      p.published = "TRUE"
      p.order_index = 3
    end
    staff_list.save

    contact_us = Page.where(:permalink => "contact-us").first.clone
    contact_us.created_at = contact_us.updated_at = nil
    contact_us.parent_id = about_parent_id
    contact_us.site_id=generic_site_id
    contact_us.order_index=4
    contact_us.save

    of_interest = Page.new do |p|
      p.site_id = generic_site_id
      p.parent_id = about_parent_id
      p.title =  "Of Interest"
      p.permalink = "of-interest"
      p.published = "TRUE"
      p.order_index = 5
    end
    of_interest.save
  end

  def self.down
    generic_site_id = Site.where(:name => "generic").select("id").first.id
    Page.destroy_all(:site_id => generic_site_id, :permalink => "top-things-you-should-know-about-the-data")
    Page.destroy_all(:site_id => generic_site_id, :permalink => "data-guidance")
    Page.destroy_all(:site_id => generic_site_id, :permalink => "purpose")
    Page.destroy_all(:site_id => generic_site_id, :permalink => "getting-on-the-map")
    Page.destroy_all(:site_id => generic_site_id, :permalink => "staff-list")
    Page.destroy_all(:site_id => generic_site_id, :permalink => "contact-us")
    Page.destroy_all(:site_id => generic_site_id, :permalink => "of-interest")
  end
end
