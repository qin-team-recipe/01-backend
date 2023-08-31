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

ActiveRecord::Schema[7.0].define(version: 2023_08_31_105645) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cart_items", force: :cascade do |t|
    t.bigint "cart_list_id", null: false
    t.string "name", null: false
    t.boolean "is_checked", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", null: false
    t.index ["cart_list_id"], name: "index_cart_items_on_cart_list_id"
  end

  create_table "cart_lists", force: :cascade do |t|
    t.bigint "recipe_id"
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.integer "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "own_notes", null: false
    t.index ["recipe_id"], name: "index_cart_lists_on_recipe_id"
    t.index ["user_id", "recipe_id"], name: "index_cart_lists_on_user_id_and_recipe_id", unique: true
    t.index ["user_id"], name: "index_cart_lists_on_user_id"
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
    t.integer "position", null: false
    t.index ["recipe_id", "position"], name: "index_materials_on_recipe_id_and_position", unique: true
    t.index ["recipe_id"], name: "index_materials_on_recipe_id"
  end

  create_table "recipe_external_links", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.string "url", null: false
    t.string "url_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id", "url"], name: "index_recipe_external_links_on_recipe_id_and_url", unique: true
    t.index ["recipe_id", "url_type"], name: "index_recipe_external_links_on_recipe_id_and_url_type", unique: true
    t.index ["recipe_id"], name: "index_recipe_external_links_on_recipe_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "thumbnail"
    t.integer "serving_size", null: false
    t.boolean "is_draft", default: false, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_public", default: true, null: false
    t.index ["user_id"], name: "index_recipes_on_user_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "follower_id", null: false
    t.bigint "followed_id", null: false
    t.index ["followed_id"], name: "index_relationships_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

  create_table "steps", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", null: false
    t.index ["recipe_id", "position"], name: "index_steps_on_recipe_id_and_position", unique: true
    t.index ["recipe_id"], name: "index_steps_on_recipe_id"
  end

  create_table "user_external_links", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "url", null: false
    t.string "url_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "url"], name: "index_user_external_links_on_user_id_and_url", unique: true
    t.index ["user_id", "url_type"], name: "index_user_external_links_on_user_id_and_url_type", unique: true
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
    t.string "domain", null: false
    t.string "user_type", null: false
    t.string "sns_id"
    t.string "thumnail"
    t.index ["domain"], name: "index_users_on_domain", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "cart_items", "cart_lists"
  add_foreign_key "cart_lists", "recipes"
  add_foreign_key "cart_lists", "users"
  add_foreign_key "favorite_recipes", "recipes"
  add_foreign_key "favorite_recipes", "users"
  add_foreign_key "materials", "recipes"
  add_foreign_key "recipe_external_links", "recipes"
  add_foreign_key "recipes", "users"
  add_foreign_key "relationships", "users", column: "followed_id"
  add_foreign_key "relationships", "users", column: "follower_id"
  add_foreign_key "steps", "recipes"
  add_foreign_key "user_external_links", "users"
end
