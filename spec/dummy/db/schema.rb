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

ActiveRecord::Schema.define(:version => 20120310195447) do

  create_table "date_time_testers", :force => true do |t|
    t.datetime "test"
  end

  create_table "field_format_testers", :force => true do |t|
    t.integer  "integer_field"
    t.float    "float_field"
    t.decimal  "decimal_field"
    t.date     "date_field"
    t.time     "time_field"
    t.datetime "datetime_field"
    t.datetime "timestamp_field"
    t.boolean  "boolean_field"
    t.text     "text_field"
    t.string   "email_field"
    t.string   "phone_field"
    t.string   "url_field"
    t.string   "string_field"
  end

  create_table "nobel_prize_winners", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.date     "birthdate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nobel_prizes", :force => true do |t|
    t.integer "nobel_prize_winner_id"
    t.string  "category"
    t.integer "year"
    t.boolean "shared"
  end

end
