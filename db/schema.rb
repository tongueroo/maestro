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

ActiveRecord::Schema.define(version: 2019_05_09_223701) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "maestro_buyer_rules", force: :cascade do |t|
    t.bigint "maestro_buyer_id"
    t.string "left_operand"
    t.string "operator"
    t.string "right_operand"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["maestro_buyer_id"], name: "index_maestro_buyer_rules_on_maestro_buyer_id"
  end

  create_table "maestro_buyers", force: :cascade do |t|
    t.string "name"
    t.bigint "phone"
    t.string "transfer_type"
    t.string "web_hook"
    t.string "web_hook_trigger_type"
    t.integer "call_cap_concurrent"
    t.integer "call_cap_daily"
    t.integer "call_cap_hourly"
    t.integer "call_cap_monthly"
    t.bigint "call_cap_lifetime"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "maestro_campaign_buyers", force: :cascade do |t|
    t.bigint "maestro_campaign_id"
    t.bigint "maestro_buyer_id"
    t.integer "priority", limit: 2
    t.integer "weight", limit: 2
    t.string "web_hook"
    t.string "web_hook_trigger_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["maestro_buyer_id"], name: "index_maestro_campaign_buyers_on_maestro_buyer_id"
    t.index ["maestro_campaign_id"], name: "index_maestro_campaign_buyers_on_maestro_campaign_id"
  end

  create_table "maestro_campaigns", force: :cascade do |t|
    t.string "name"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "maestro_phone_campaigns", id: false, force: :cascade do |t|
    t.bigint "phone"
    t.bigint "maestro_campaign_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["maestro_campaign_id"], name: "index_maestro_phone_campaigns_on_maestro_campaign_id"
    t.index ["phone"], name: "index_maestro_phone_campaigns_on_phone", unique: true
  end

  add_foreign_key "maestro_buyer_rules", "maestro_buyers"
  add_foreign_key "maestro_campaign_buyers", "maestro_buyers"
  add_foreign_key "maestro_campaign_buyers", "maestro_campaigns"
  add_foreign_key "maestro_phone_campaigns", "maestro_campaigns"
end
