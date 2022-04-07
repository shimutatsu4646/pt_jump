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

ActiveRecord::Schema.define(version: 2022_04_04_130905) do

  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "availability_schedules", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "trainee_id", null: false
    t.bigint "day_of_week_id", null: false
    t.index ["day_of_week_id"], name: "index_availability_schedules_on_day_of_week_id"
    t.index ["trainee_id", "day_of_week_id"], name: "index_availability_schedules_on_trainee_id_and_day_of_week_id", unique: true
  end

  create_table "chats", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "trainee_id", null: false
    t.bigint "trainer_id", null: false
    t.boolean "from_trainee", null: false
    t.text "content", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["trainee_id"], name: "index_chats_on_trainee_id"
    t.index ["trainer_id"], name: "index_chats_on_trainer_id"
  end

  create_table "cities", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "prefecture_id", null: false
    t.index ["prefecture_id"], name: "index_cities_on_prefecture_id"
  end

  create_table "cities_trainees", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "trainee_id", null: false
    t.bigint "city_id", null: false
    t.index ["city_id"], name: "index_cities_trainees_on_city_id"
    t.index ["trainee_id", "city_id"], name: "index_cities_trainees_on_trainee_id_and_city_id", unique: true
  end

  create_table "cities_trainers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "trainer_id", null: false
    t.bigint "city_id", null: false
    t.index ["city_id"], name: "index_cities_trainers_on_city_id"
    t.index ["trainer_id", "city_id"], name: "index_cities_trainers_on_trainer_id_and_city_id", unique: true
  end

  create_table "day_of_weeks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "instruction_schedules", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "trainer_id", null: false
    t.bigint "day_of_week_id", null: false
    t.index ["day_of_week_id"], name: "index_instruction_schedules_on_day_of_week_id"
    t.index ["trainer_id", "day_of_week_id"], name: "index_instruction_schedules_on_trainer_id_and_day_of_week_id", unique: true
  end

  create_table "prefectures", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "region_id", null: false
    t.index ["region_id"], name: "index_prefectures_on_region_id"
  end

  create_table "regions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "trainees", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name", null: false
    t.integer "age", null: false
    t.integer "gender", null: false
    t.text "introduction"
    t.boolean "chat_acceptance", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "category"
    t.integer "instruction_method"
    t.index ["email"], name: "index_trainees_on_email", unique: true
    t.index ["reset_password_token"], name: "index_trainees_on_reset_password_token", unique: true
  end

  create_table "trainers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name", null: false
    t.integer "age", null: false
    t.integer "gender", null: false
    t.text "introduction"
    t.integer "min_fee"
    t.integer "instruction_period"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "category"
    t.integer "instruction_method"
    t.index ["email"], name: "index_trainers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_trainers_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "availability_schedules", "day_of_weeks"
  add_foreign_key "availability_schedules", "trainees"
  add_foreign_key "chats", "trainees"
  add_foreign_key "chats", "trainers"
  add_foreign_key "cities", "prefectures"
  add_foreign_key "cities_trainees", "cities"
  add_foreign_key "cities_trainees", "trainees"
  add_foreign_key "cities_trainers", "cities"
  add_foreign_key "cities_trainers", "trainers"
  add_foreign_key "instruction_schedules", "day_of_weeks"
  add_foreign_key "instruction_schedules", "trainers"
  add_foreign_key "prefectures", "regions"
end
