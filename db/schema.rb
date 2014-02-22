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

ActiveRecord::Schema.define(:version => 20131114144328) do

  create_table "age_ranges", :force => true do |t|
    t.integer  "age_left"
    t.integer  "age_right"
    t.integer  "audience_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "applications", :force => true do |t|
    t.string "name"
  end

  create_table "audiences", :force => true do |t|
    t.integer  "campaign_id"
    t.integer  "gender"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "campaign_before_id"
  end

  create_table "campaign_items", :force => true do |t|
    t.integer "campaign_id"
    t.string  "textUrl"
    t.integer "selected_count", :default => 0
  end

  create_table "campaign_stats", :force => true do |t|
    t.integer "campaign_id"
    t.integer "campaignItem_id"
    t.integer "click"
  end

  create_table "campaigns", :force => true do |t|
    t.integer "client_id"
    t.integer "type_ad",             :default => 0
    t.string  "caption"
    t.integer "purchased",           :default => 0
    t.integer "showed",              :default => 0
    t.boolean "approved",            :default => false
    t.boolean "started",             :default => false
    t.boolean "multiple"
    t.string  "image_url"
    t.string  "border_color"
    t.string  "title_color"
    t.string  "background_url"
    t.string  "image_question_link"
    t.integer "target_device"
  end

  create_table "clicks", :force => true do |t|
    t.date     "date"
    t.string   "sdkkey"
    t.integer  "campaign_id"
    t.integer  "answer_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "user_id"
  end

  create_table "clients", :force => true do |t|
    t.string   "email",                                                :default => "",    :null => false
    t.string   "encrypted_password",                                   :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "admin",                                                :default => false
    t.string   "username"
    t.decimal  "balance",                :precision => 8, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                              :null => false
    t.datetime "updated_at",                                                              :null => false
    t.boolean  "developer"
  end

  add_index "clients", ["email"], :name => "index_clients_on_email", :unique => true
  add_index "clients", ["reset_password_token"], :name => "index_clients_on_reset_password_token", :unique => true

  create_table "locations", :force => true do |t|
    t.string   "country"
    t.string   "state"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "user_id"
    t.integer  "campaign_id"
  end

  create_table "paypal_payments", :force => true do |t|
    t.string   "track_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "profiles", :force => true do |t|
    t.integer  "client_id"
    t.string   "description"
    t.string   "company"
    t.string   "name"
    t.string   "address"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "sdkkeys", :force => true do |t|
    t.string   "key"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "client_id"
    t.string   "name"
    t.boolean  "active",     :default => true
    t.integer  "clicks",     :default => 0
  end

  create_table "settings", :force => true do |t|
    t.string   "var",                      :null => false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", :limit => 30
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "settings", ["thing_type", "thing_id", "var"], :name => "index_settings_on_thing_type_and_thing_id_and_var", :unique => true

  create_table "users", :force => true do |t|
    t.string   "macaddress"
    t.integer  "age"
    t.integer  "sex"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "location_id"
    t.string   "build_version"
  end

end
