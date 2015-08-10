class AddIatiProjectFields < ActiveRecord::Migration
  def self.up
    add_column :projects, :budget_currency, :string
    add_column :projects, :budget_value_date, :date
    add_column :projects, :target_project_reach, :integer
    add_column :projects, :actual_project_reach, :integer
    add_column :projects, :project_reach_unit, :string
  end

  def self.down
    remove_column :projects, :budget_currency
    remove_column :projects, :budget_value_date
    remove_column :projects, :target_project_reach
    remove_column :projects, :actual_project_reach
    remove_column :projects, :project_reach_unit
  end
end
