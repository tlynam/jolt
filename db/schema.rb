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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150604033853) do

  create_table "sales", force: :cascade do |t|
    t.integer  "units",              limit: 4,                   null: false
    t.string   "first_name",         limit: 255,                 null: false
    t.string   "last_name",          limit: 255,                 null: false
    t.string   "address",            limit: 255,                 null: false
    t.string   "address2",           limit: 255
    t.string   "city",               limit: 255,                 null: false
    t.integer  "zip",                limit: 4,                   null: false
    t.string   "country",            limit: 255,                 null: false
    t.integer  "credit_card_number", limit: 4,                   null: false
    t.date     "credit_card_date",                               null: false
    t.integer  "credit_card_ccv",    limit: 4,                   null: false
    t.boolean  "shipped",            limit: 1,   default: false, null: false
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

end