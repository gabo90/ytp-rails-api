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

ActiveRecord::Schema.define(version: 2019_02_08_071852) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_transactions", force: :cascade do |t|
    t.bigint "account_id"
    t.integer "transaction_type", default: 0
    t.decimal "amount", precision: 8, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_account_transactions_on_account_id"
    t.index ["transaction_type"], name: "index_account_transactions_on_transaction_type"
  end

  create_table "accounts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "account_type", default: 0
    t.decimal "balance", precision: 13, scale: 2, default: "0.0"
    t.string "clabe", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_type"], name: "index_accounts_on_account_type"
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "role", default: 1
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "account_transactions", "accounts"
  add_foreign_key "accounts", "users"
end
