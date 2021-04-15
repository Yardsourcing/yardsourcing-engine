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

ActiveRecord::Schema.define(version: 2021_04_15_003048) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.bigint "yard_id"
    t.integer "renter_id"
    t.integer "status", default: 0
    t.string "booking_name"
    t.date "date"
    t.time "time"
    t.integer "duration"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["yard_id"], name: "index_bookings_on_yard_id"
  end

  create_table "purposes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "yard_purposes", force: :cascade do |t|
    t.bigint "yard_id"
    t.bigint "purpose_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["purpose_id"], name: "index_yard_purposes_on_purpose_id"
    t.index ["yard_id"], name: "index_yard_purposes_on_yard_id"
  end

  create_table "yards", force: :cascade do |t|
    t.integer "host_id"
    t.string "name"
    t.string "street_address"
    t.string "city"
    t.string "state"
    t.string "zipcode"
    t.decimal "price"
    t.string "description"
    t.string "availability"
    t.string "payment"
    t.string "photo_url_1"
    t.string "photo_url_2"
    t.string "photo_url_3"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "bookings", "yards"
  add_foreign_key "yard_purposes", "purposes"
  add_foreign_key "yard_purposes", "yards"
end
