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

ActiveRecord::Schema.define(:version => 20120825124415) do

  create_table "efars", :force => true do |t|
    t.string   "surname",                                :null => false
    t.string   "first_name",                             :null => false
    t.string   "address",                                :null => false
    t.string   "community"
    t.string   "postal_code",                            :null => false
    t.string   "city",                                   :null => false
    t.string   "province"
    t.string   "country",                                :null => false
    t.string   "contact_number",                         :null => false
    t.string   "certification_level"
    t.string   "lat"
    t.string   "long"
    t.boolean  "invalid_address",     :default => false
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

end
