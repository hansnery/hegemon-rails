# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_02_23_232900) do
  create_table "maps", force: :cascade do |t|
    t.string "name"
    t.integer "min_players"
    t.integer "max_players"
    t.integer "num_players"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nearby_provinces", id: false, force: :cascade do |t|
    t.integer "province_id"
    t.integer "nearby_province_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nearby_province_id"], name: "index_nearby_provinces_on_nearby_province_id"
    t.index ["province_id", "nearby_province_id"], name: "index_nearby_provinces_on_province_id_and_nearby_province_id", unique: true
    t.index ["province_id"], name: "index_nearby_provinces_on_province_id"
  end

  create_table "provinces", force: :cascade do |t|
    t.string "name"
    t.string "owner"
    t.string "geometry"
    t.integer "armies"
    t.integer "map_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["map_id"], name: "index_provinces_on_map_id"
  end

  add_foreign_key "provinces", "maps"
end
