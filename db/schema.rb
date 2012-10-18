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

ActiveRecord::Schema.define(:version => 20121018220308) do

  create_table "admins", :force => true do |t|
    t.string   "full_name",       :null => false
    t.string   "email",           :null => false
    t.string   "password_digest", :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true

  create_table "community_centers", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "address",     :null => false
    t.string   "suburb"
    t.string   "postal_code", :null => false
    t.string   "city",        :null => false
    t.string   "province"
    t.string   "country",     :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "dispatchers", :force => true do |t|
    t.string   "full_name",       :null => false
    t.string   "username",        :null => false
    t.string   "password_digest", :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "dispatchers", ["username"], :name => "index_dispatchers_on_username", :unique => true

  create_table "efars", :force => true do |t|
    t.string   "surname",                                 :null => false
    t.string   "first_names",         :default => "Anon"
    t.integer  "community_center_id",                     :null => false
    t.string   "contact_number",                          :null => false
    t.string   "certification_level"
    t.string   "address",                                 :null => false
    t.string   "suburb"
    t.string   "postal_code"
    t.string   "city",                                    :null => false
    t.string   "province"
    t.string   "country",                                 :null => false
    t.string   "lat"
    t.string   "long"
    t.boolean  "invalid_address",     :default => false
    t.boolean  "is_mobile",           :default => false
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  create_table "head_efars", :force => true do |t|
    t.string   "full_name",           :null => false
    t.integer  "community_center_id", :null => false
    t.string   "email",               :null => false
    t.string   "password_digest",     :null => false
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "head_efars", ["email"], :name => "index_head_efars_on_email", :unique => true

  create_table "researchers", :force => true do |t|
    t.string   "full_name",       :null => false
    t.string   "email",           :null => false
    t.string   "affiliation"
    t.string   "password_digest", :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "researchers", ["email"], :name => "index_researchers_on_email", :unique => true

end
