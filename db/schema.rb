# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20130213123443) do

  create_table "activity_logs", :force => true do |t|
    t.string   "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "admins", :force => true do |t|
    t.string   "full_name",       :null => false
    t.string   "email",           :null => false
    t.string   "password_digest", :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true

  create_table "candidate_efars", :force => true do |t|
    t.string   "full_name",                    :null => false
    t.string   "full_address"
    t.string   "contact_number",               :null => false
    t.integer  "community_center_id",          :null => false
    t.string   "training_score"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "first_invite_status_part_one"
    t.string   "first_invite_status_part_two"
    t.string   "second_invite_part_one"
    t.string   "second_invite_part_two"
    t.string   "third_invite_part_one"
    t.string   "third_invite_part_two"
  end

  create_table "community_centers", :force => true do |t|
    t.string   "name",              :null => false
    t.string   "street",            :null => false
    t.string   "suburb"
    t.string   "postal_code",       :null => false
    t.string   "city",              :null => false
    t.string   "province"
    t.string   "country",           :null => false
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.float    "lat"
    t.float    "lng"
    t.string   "location_type"
    t.string   "formatted_address"
  end

  create_table "dispatch_messages", :force => true do |t|
    t.integer  "emergency_id",             :null => false
    t.integer  "efar_id",                  :null => false
    t.string   "state"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.string   "clickatell_id"
    t.string   "clickatell_error_message"
    t.integer  "efar_location_id",         :null => false
  end

  add_index "dispatch_messages", ["clickatell_id"], :name => "index_dispatch_messages_on_clickatell_id"

  create_table "dispatchers", :force => true do |t|
    t.string   "full_name",       :null => false
    t.string   "username",        :null => false
    t.string   "password_digest", :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "dispatchers", ["username"], :name => "index_dispatchers_on_username", :unique => true

  create_table "dispatches", :force => true do |t|
    t.integer  "dispatcher_id",      :null => false
    t.string   "emergency_category"
    t.integer  "geolocation_id"
    t.integer  "township_id"
    t.string   "landmarks"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "efar_locations", :force => true do |t|
    t.integer "efar_id",           :null => false
    t.string  "occupied_at"
    t.string  "formatted_address", :null => false
    t.float   "lat",               :null => false
    t.float   "lng",               :null => false
    t.string  "location_type"
  end

  create_table "efars", :force => true do |t|
    t.string  "full_name",           :null => false
    t.integer "community_center_id", :null => false
    t.integer "slum_id"
    t.string  "contact_number",      :null => false
  end

  create_table "emergencies", :force => true do |t|
    t.integer  "dispatcher_id",     :null => false
    t.string   "input_address",     :null => false
    t.string   "category"
    t.string   "state"
    t.string   "formatted_address"
    t.float    "lat",               :null => false
    t.float    "lng",               :null => false
    t.string   "location_type"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "landmarks"
  end

  create_table "geolocations", :force => true do |t|
    t.float    "lat",               :null => false
    t.float    "lng",               :null => false
    t.string   "formatted_address", :null => false
    t.string   "location_type"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "head_efars", :force => true do |t|
    t.string   "full_name",           :null => false
    t.integer  "community_center_id", :null => false
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "contact_number",      :null => false
  end

  create_table "researchers", :force => true do |t|
    t.string   "full_name",       :null => false
    t.string   "email",           :null => false
    t.string   "affiliation"
    t.string   "password_digest", :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "researchers", ["email"], :name => "index_researchers_on_email", :unique => true

  create_table "slum_dispatch_messages", :force => true do |t|
    t.integer  "slum_emergency_id",                              :null => false
    t.integer  "efar_id",                                        :null => false
    t.string   "clickatell_error_message"
    t.string   "state",                    :default => "queued"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
  end

  create_table "slum_emergencies", :force => true do |t|
    t.integer  "slum_id",       :null => false
    t.string   "category"
    t.string   "shack_number"
    t.integer  "dispatcher_id", :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "landmarks"
  end

  create_table "slums", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "townships", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
