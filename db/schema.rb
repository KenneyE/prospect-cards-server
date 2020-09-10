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

ActiveRecord::Schema.define(version: 2020_09_10_155124) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.text "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "jwt_deny_list", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
    t.index ["jti"], name: "index_jwt_deny_list_on_jti"
  end

  create_table "listings", force: :cascade do |t|
    t.text "title", null: false
    t.text "description", null: false
    t.bigint "user_id", null: false
    t.integer "price", null: false
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "player_id", null: false
    t.bigint "category_id", null: false
    t.bigint "product_type_id", null: false
    t.index ["category_id"], name: "index_listings_on_category_id"
    t.index ["player_id"], name: "index_listings_on_player_id"
    t.index ["product_type_id"], name: "index_listings_on_product_type_id"
    t.index ["user_id"], name: "index_listings_on_user_id"
  end

  create_table "player_interests", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "player_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["player_id"], name: "index_player_interests_on_player_id"
    t.index ["user_id"], name: "index_player_interests_on_user_id"
  end

  create_table "players", force: :cascade do |t|
    t.text "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "product_types", force: :cascade do |t|
    t.text "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "stripe_accounts", force: :cascade do |t|
    t.text "token"
    t.boolean "charges_enabled", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "details_submitted", default: false, null: false
    t.index ["token"], name: "index_stripe_accounts_on_token"
  end

  create_table "stripe_customers", force: :cascade do |t|
    t.text "token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["token"], name: "index_stripe_customers_on_token"
  end

  create_table "stripe_payment_intents", force: :cascade do |t|
    t.text "token", null: false
    t.integer "amount", null: false
    t.text "client_secret", null: false
    t.text "customer", null: false
    t.jsonb "metadata", null: false
    t.text "status", null: false
    t.text "on_behalf_of"
    t.text "transfer_group"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "stripe_subscriptions", force: :cascade do |t|
    t.text "token", null: false
    t.text "customer", null: false
    t.boolean "cancel_at_period_end", null: false
    t.integer "current_period_start", null: false
    t.integer "current_period_end", null: false
    t.integer "quantity", null: false
    t.text "status", null: false
    t.integer "trial_end"
    t.text "plan", null: false
    t.integer "created", null: false
    t.jsonb "metadata"
    t.jsonb "discount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "stripe_account_id"
    t.text "stripe_customer_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "listings", "categories"
  add_foreign_key "listings", "players"
  add_foreign_key "listings", "product_types"
  add_foreign_key "listings", "users"
  add_foreign_key "player_interests", "players"
  add_foreign_key "player_interests", "users"
end
