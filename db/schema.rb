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

ActiveRecord::Schema[7.0].define(version: 2023_08_11_032137) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cart_items", force: :cascade do |t|
    t.bigint "cart_list_id", null: false
    t.string "name", null: false
    t.string "memo"
    t.boolean "is_checked", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_list_id"], name: "index_cart_items_on_cart_list_id"
  end

  create_table "cart_lists", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.integer "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_cart_lists_on_recipe_id"
    t.index ["user_id"], name: "index_cart_lists_on_user_id"
  end

  create_table "favorite_chefs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "chef_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chef_id"], name: "index_favorite_chefs_on_chef_id"
    t.index ["user_id", "chef_id"], name: "index_favorite_chefs_on_user_id_and_chef_id", unique: true
    t.index ["user_id"], name: "index_favorite_chefs_on_user_id"
  end

  create_table "favorite_recipes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "recipe_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_favorite_recipes_on_recipe_id"
    t.index ["user_id", "recipe_id"], name: "index_favorite_recipes_on_user_id_and_recipe_id", unique: true
    t.index ["user_id"], name: "index_favorite_recipes_on_user_id"
  end

  create_table "materials", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["recipe_id"], name: "index_materials_on_recipe_id"
  end

  create_table "recipe_external_links", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.string "url"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_recipe_external_links_on_recipe_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "thumbnail"
    t.integer "serving_size"
    t.boolean "is_draft", default: false, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_public", default: true
    t.index ["user_id"], name: "index_recipes_on_user_id"
  end

  create_table "steps", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.string "title", null: false
    t.string "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_steps_on_recipe_id"
  end

  create_table "user_external_links", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "url"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_external_links_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.string "domain"
    t.string "role"
    t.string "sns_id"
    t.string "thumnail"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "cart_items", "cart_lists"
  add_foreign_key "cart_lists", "recipes"
  add_foreign_key "cart_lists", "users"
  add_foreign_key "favorite_chefs", "users"
  add_foreign_key "favorite_recipes", "recipes"
  add_foreign_key "favorite_recipes", "users"
  add_foreign_key "materials", "recipes"
  add_foreign_key "recipe_external_links", "recipes"
  add_foreign_key "recipes", "users"
  add_foreign_key "steps", "recipes"
  add_foreign_key "user_external_links", "users"
end
