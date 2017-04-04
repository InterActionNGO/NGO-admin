class ResetOrganizationIdToId < ActiveRecord::Migration
  def self.up
    execute <<-SQL
      UPDATE organizations SET organization_id = id
    SQL
  end

  def self.down
    # Nothing to run in the down direction
  end
end
