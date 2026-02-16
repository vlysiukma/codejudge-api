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

ActiveRecord::Schema[8.1].define(version: 2025_02_16_000004) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "assignments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description", null: false
    t.string "difficulty"
    t.integer "max_score", default: 0, null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
  end

  create_table "submissions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "assignment_id", null: false
    t.datetime "created_at", null: false
    t.integer "final_score"
    t.text "instructor_comment"
    t.string "language", null: false
    t.integer "manual_score"
    t.text "source_code", null: false
    t.string "status", default: "pending", null: false
    t.jsonb "test_results", default: []
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["assignment_id"], name: "index_submissions_on_assignment_id"
    t.index ["user_id"], name: "index_submissions_on_user_id"
  end

  create_table "test_cases", force: :cascade do |t|
    t.bigint "assignment_id", null: false
    t.datetime "created_at", null: false
    t.text "expected_output", null: false
    t.text "input_data", null: false
    t.boolean "is_hidden", default: true, null: false
    t.integer "points", default: 5, null: false
    t.datetime "updated_at", null: false
    t.index ["assignment_id"], name: "index_test_cases_on_assignment_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "role", default: "student", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "submissions", "assignments"
  add_foreign_key "submissions", "users"
  add_foreign_key "test_cases", "assignments"
end
