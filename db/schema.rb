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

ActiveRecord::Schema[7.0].define(version: 2023_03_30_152649) do
  create_table "games", force: :cascade do |t|
    t.string "name"
    t.boolean "private"
    t.integer "player_turn", default: 0
    t.integer "turns_played", default: 1
    t.string "phase", default: "mustering"
    t.boolean "finished", default: false
    t.integer "winner"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "maps", force: :cascade do |t|
    t.string "name"
    t.integer "min_players"
    t.integer "max_players"
    t.integer "num_players"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "game_id", null: false
    t.index ["game_id"], name: "index_maps_on_game_id"
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

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.integer "map_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["map_id"], name: "index_players_on_map_id"
  end

  create_table "provinces", force: :cascade do |t|
    t.string "name"
    t.string "owner"
    t.string "color"
    t.string "geometry"
    t.integer "armies"
    t.integer "map_id"
    t.integer "player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["map_id"], name: "index_provinces_on_map_id"
    t.index ["player_id"], name: "index_provinces_on_player_id"
  end

  add_foreign_key "maps", "games"
  add_foreign_key "players", "maps"
  add_foreign_key "provinces", "maps"
  add_foreign_key "provinces", "players"
end
