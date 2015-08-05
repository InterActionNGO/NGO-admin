class ChangesOrganizationAttributes < ActiveRecord::Migration
  def self.up
    add_column :organizations, :organization_type, :string
    add_column :organizations, :iati_organizationid, :string
    add_column :organizations, :publishing_to_iati, :boolean, :default => :false
    add_column :organizations, :membership_status, :string, :default => 'active'
    remove_volumn :organizations,
  end

  def self.down
  end
end
