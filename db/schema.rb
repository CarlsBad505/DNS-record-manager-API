# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_12_26_215355) do

  create_table "records", force: :cascade do |t|
    t.integer "zone_id", null: false
    t.string "name", null: false
    t.string "record_type", null: false
    t.string "data", null: false
    t.integer "ttl", default: 3600
    t.boolean "soa", default: false
    t.integer "revised_at"
    t.integer "refresh_time"
    t.integer "retry_time"
    t.integer "expires_at"
    t.string "domain_email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["zone_id"], name: "index_records_on_zone_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.text "hashed_token", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "zones", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_zones_on_user_id"
  end

end
