# == Schema Information
#
# Table name: layers
#
#  id             :integer         not null, primary key
#  title          :string(255)     
#  description 	  :text            
#  credits     	  :text 
#  sql			  :text           
#  date	       	  :date            
#  min       	  :integer            
#  max       	  :integer            
#  units       	  :integer            
#  status      	  :boolean    
#  cartodb_table  :string     
#

class Layer < ActiveRecord::Base
  # attr_accessible :site_layers_attributes
  has_many  :site_layers
  has_many  :site, :through => :site_layers
  # accepts_nested_attributes_for :site_layers

  # to get only id and name
  def self.get_select_values
    scoped.select("id,title").order("title ASC")
  end  
end