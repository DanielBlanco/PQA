# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090420163934) do

  create_table "code_reviews", :force => true do |t|
    t.string   "module",       :limit => 200
    t.integer  "line_number"
    t.text     "description",                                    :null => false
    t.string   "submitted_by", :limit => 500,                    :null => false
    t.string   "owner",        :limit => 500,                    :null => false
    t.boolean  "resolved",                    :default => false, :null => false
    t.integer  "lock_version",                :default => 0,     :null => false
    t.integer  "project_id",                                     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ticket"
  end

  create_table "configurations", :force => true do |t|
    t.string   "name",                         :null => false
    t.text     "config_values",                :null => false
    t.integer  "lock_version",  :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deployments", :force => true do |t|
    t.string   "file",                 :limit => 500,                    :null => false
    t.string   "file_type",            :limit => 200,                    :null => false
    t.boolean  "environment_specific",                :default => false, :null => false
    t.string   "action",               :limit => 20,                     :null => false
    t.integer  "lock_version",                        :default => 0,     :null => false
    t.integer  "project_id",                                             :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "section"
  end

  create_table "envspecifics", :force => true do |t|
    t.string   "file",                        :null => false
    t.integer  "lock_version", :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "performances", :force => true do |t|
    t.text     "description",                                     :null => false
    t.string   "url",          :limit => 1000
    t.string   "tester",       :limit => 200,                     :null => false
    t.string   "environment",  :limit => 1000,                    :null => false
    t.boolean  "pass",                         :default => false, :null => false
    t.text     "result",                                          :null => false
    t.integer  "project_id",                                      :null => false
    t.integer  "lock_version",                 :default => 0,     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.date     "started_on"
    t.boolean  "active",                      :default => true, :null => false
    t.integer  "lock_version",                :default => 0,    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",         :limit => 100,                   :null => false
    t.string   "ticket"
  end

  create_table "unit_tests", :force => true do |t|
    t.string   "module",         :limit => 200
    t.text     "description",                                  :null => false
    t.text     "result",                                       :null => false
    t.text     "notes",                                        :null => false
    t.integer  "lock_version",                  :default => 0, :null => false
    t.integer  "project_id",                                   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "pass_brands"
    t.string   "fail_brands"
    t.string   "fsd_usecase_id"
  end

  create_table "walkthroughs", :force => true do |t|
    t.text     "description",                                    :null => false
    t.string   "url",          :limit => 500
    t.integer  "severity"
    t.text     "user",                                           :null => false
    t.string   "owner",        :limit => 500,                    :null => false
    t.boolean  "resolved",                    :default => false, :null => false
    t.integer  "lock_version",                :default => 0,     :null => false
    t.integer  "project_id",                                     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "issue"
  end

end
