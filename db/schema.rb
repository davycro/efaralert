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

ActiveRecord::Schema.define(:version => 20140723114026) do

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

  create_table "alert_sms", :force => true do |t|
    t.integer  "efar_id",    :null => false
    t.integer  "alert_id",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "alerts", :force => true do |t|
    t.string   "given_location"
    t.string   "landmarks"
    t.string   "incident_type"
    t.float    "lat"
    t.float    "lng"
    t.string   "formatted_address"
    t.string   "location_type"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.boolean  "control_group",            :default => false
    t.float    "distance_of_nearest_efar"
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

  create_table "efars", :force => true do |t|
    t.string  "full_name",                                :null => false
    t.integer "community_center_id",                      :null => false
    t.string  "contact_number",                           :null => false
    t.float   "lat"
    t.float   "lng"
    t.string  "formatted_address"
    t.string  "location_type"
    t.string  "given_address"
    t.string  "training_level",      :default => "Basic"
    t.date    "training_date"
    t.string  "password_digest"
    t.integer "study_invite_id"
    t.boolean "alert_subscriber",    :default => false
  end

  add_index "efars", ["training_date"], :name => "index_efars_on_training_date"

  create_table "study_invites", :force => true do |t|
    t.integer  "efar_id",                       :null => false
    t.boolean  "accepted",   :default => false
    t.boolean  "rejected",   :default => false
    t.boolean  "opened",     :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "text_messages", :force => true do |t|
    t.integer  "efar_id",                                 :null => false
    t.integer  "dispatcher_id"
    t.text     "content"
    t.boolean  "viewed_by_dispatcher", :default => false
    t.string   "sender_name"
    t.string   "sender_class_name"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

end
