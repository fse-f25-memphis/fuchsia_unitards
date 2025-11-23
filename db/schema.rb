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

ActiveRecord::Schema[7.1].define(version: 2025_11_22_233411) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cart_items", force: :cascade do |t|
    t.bigint "cart_id", null: false
    t.bigint "unitard_id", null: false
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["unitard_id"], name: "index_cart_items_on_unitard_id"
  end

  create_table "carts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "unitard_id", null: false
    t.integer "quantity"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["unitard_id"], name: "index_order_items_on_unitard_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.decimal "total"
    t.string "status"
    t.boolean "gift"
    t.string "recipient_name"
    t.string "recipient_email"
    t.text "gift_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "unitard_id", null: false
    t.integer "rating"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unitard_id"], name: "index_reviews_on_unitard_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "support_tickets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "subject"
    t.text "message"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_support_tickets_on_user_id"
  end

  create_table "trade_items", force: :cascade do |t|
    t.bigint "trade_id", null: false
    t.bigint "unitard_id", null: false
    t.string "side", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trade_id"], name: "index_trade_items_on_trade_id"
    t.index ["unitard_id"], name: "index_trade_items_on_unitard_id"
  end

  create_table "trades", force: :cascade do |t|
    t.bigint "proposer_id", null: false
    t.bigint "recipient_id", null: false
    t.string "status", default: "pending"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["proposer_id"], name: "index_trades_on_proposer_id"
    t.index ["recipient_id"], name: "index_trades_on_recipient_id"
  end

  create_table "unitards", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.decimal "price", precision: 10, scale: 2, null: false
    t.string "cut"
    t.string "size"
    t.string "sleeves"
    t.string "graphic"
    t.string "color"
    t.text "special_features"
    t.integer "stock", default: 0, null: false
    t.bigint "vendor_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["vendor_id"], name: "index_unitards_on_vendor_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wishlist_items", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "unitard_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unitard_id"], name: "index_wishlist_items_on_unitard_id"
    t.index ["user_id"], name: "index_wishlist_items_on_user_id"
  end

  add_foreign_key "cart_items", "carts"
  add_foreign_key "cart_items", "unitards"
  add_foreign_key "carts", "users"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "unitards"
  add_foreign_key "orders", "users"
  add_foreign_key "reviews", "unitards"
  add_foreign_key "reviews", "users"
  add_foreign_key "support_tickets", "users"
  add_foreign_key "trade_items", "trades"
  add_foreign_key "trade_items", "unitards"
  add_foreign_key "trades", "users", column: "proposer_id"
  add_foreign_key "trades", "users", column: "recipient_id"
  add_foreign_key "unitards", "users", column: "vendor_id"
  add_foreign_key "wishlist_items", "unitards"
  add_foreign_key "wishlist_items", "users"
end
