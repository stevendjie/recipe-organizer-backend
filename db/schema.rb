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

ActiveRecord::Schema.define(version: 2020_05_10_212747) do

  create_table "equipment", force: :cascade do |t|
    t.integer "recipe_id", null: false
    t.string "name"
    t.boolean "in_shopping_list"
    t.integer "shopping_list_index"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["recipe_id"], name: "index_equipment_on_recipe_id"
  end

  create_table "ingredients", force: :cascade do |t|
    t.integer "recipe_id", null: false
    t.string "name"
    t.decimal "amount"
    t.string "unit"
    t.boolean "in_shopping_list"
    t.integer "shopping_list_index"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["recipe_id"], name: "index_ingredients_on_recipe_id"
  end

  create_table "instructions", force: :cascade do |t|
    t.integer "recipe_id", null: false
    t.integer "index"
    t.text "text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["recipe_id"], name: "index_instructions_on_recipe_id"
  end

  create_table "notes", force: :cascade do |t|
    t.integer "recipe_id", null: false
    t.text "text"
    t.integer "index"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["recipe_id"], name: "index_notes_on_recipe_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.string "title"
    t.integer "ready_in_minutes"
    t.text "source_url"
    t.integer "user_id", null: false
    t.decimal "scale_factor"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_recipes_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "shopping_list_email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "equipment", "recipes"
  add_foreign_key "ingredients", "recipes"
  add_foreign_key "instructions", "recipes"
  add_foreign_key "notes", "recipes"
  add_foreign_key "recipes", "users"
end
