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

ActiveRecord::Schema[8.1].define(version: 2026_07_01_120100) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "app_configs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "data_source"
    t.string "description"
    t.string "key", null: false
    t.datetime "updated_at", null: false
    t.string "value", null: false
    t.string "value_type", default: "string", null: false
    t.index ["key"], name: "index_app_configs_on_key", unique: true
  end

  create_table "reference_values", force: :cascade do |t|
    t.string "bet_type"
    t.string "category", null: false
    t.datetime "created_at", null: false
    t.string "data_source"
    t.string "description"
    t.string "key", null: false
    t.datetime "updated_at", null: false
    t.string "value", null: false
    t.string "value_type", default: "string", null: false
    t.index ["bet_type", "key"], name: "idx_reference_values_unique_bet_type_key", unique: true, where: "(bet_type IS NOT NULL)"
    t.index ["category"], name: "index_reference_values_on_category"
    t.index ["key"], name: "idx_reference_values_unique_key", unique: true, where: "(bet_type IS NULL)"
  end

  create_table "simulation_results", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "inputs_signature", null: false
    t.jsonb "results", default: {}, null: false
    t.datetime "updated_at", null: false
    t.index ["inputs_signature"], name: "index_simulation_results_on_inputs_signature", unique: true
  end

  create_table "simulations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "visitor_id", null: false
    t.index ["visitor_id"], name: "index_simulations_on_visitor_id"
  end
end
