# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140507144143) do

  create_table "changes_history_records", :force => true do |t|
    t.integer  "user_id"
    t.datetime "when"
    t.text     "how"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "what_id"
    t.string   "what_type"
    t.boolean  "reviewed",         :default => false
    t.string   "who_email"
    t.string   "who_organization"
  end

  add_index "changes_history_records", ["user_id", "what_type", "when"], :name => "index_changes_history_records_on_user_id_and_what_type_and_when"

  create_table "changes_history_records_copy", :id => false, :force => true do |t|
    t.integer  "id",               :null => false
    t.integer  "user_id"
    t.datetime "when"
    t.text     "how"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "what_id"
    t.string   "what_type"
    t.boolean  "reviewed"
    t.string   "who_email"
    t.string   "who_organization"
  end

  create_table "clusters", :force => true do |t|
    t.string "name"
  end

  create_table "clusters_projects", :id => false, :force => true do |t|
    t.integer "cluster_id"
    t.integer "project_id"
  end

  add_index "clusters_projects", ["cluster_id"], :name => "index_clusters_projects_on_cluster_id"
  add_index "clusters_projects", ["project_id"], :name => "index_clusters_projects_on_project_id"

