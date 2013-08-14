# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20130814060432) do

  create_table "code_generation_logs", force: true do |t|
    t.integer  "outlet_id"
    t.string   "outlet_name"
    t.integer  "customer_id"
    t.integer  "generated_by"
    t.integer  "feedback_id"
    t.string   "code"
    t.float    "bill_size"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cuisine_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", force: true do |t|
    t.string   "name"
    t.string   "phone_number"
    t.string   "registered_address_line_1"
    t.string   "registered_address_line_2"
    t.string   "registered_address_city"
    t.string   "registered_address_country"
    t.string   "mailing_address_line_1"
    t.string   "mailing_address_line_2"
    t.string   "mailing_address_city"
    t.string   "mailing_address_country"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "customer_admin_id"
    t.string   "email"
  end

  create_table "customers_users", force: true do |t|
    t.integer "customer_id"
    t.integer "user_id"
  end

  add_index "customers_users", ["customer_id"], name: "index_customers_users_on_customer_id", using: :btree
  add_index "customers_users", ["user_id"], name: "index_customers_users_on_user_id", using: :btree

  create_table "feedback_logs", force: true do |t|
    t.integer  "user_id"
    t.string   "user_first_name"
    t.string   "user_last_name"
    t.string   "user_email"
    t.integer  "outlet_id"
    t.string   "outlet_name"
    t.integer  "customer_id"
    t.integer  "feedback_id"
    t.string   "code"
    t.integer  "points"
    t.integer  "outlet_points_before"
    t.integer  "outlet_points_after"
    t.integer  "user_points_before"
    t.integer  "user_points_after"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feedbacks", force: true do |t|
    t.string   "code"
    t.integer  "food_quality"
    t.integer  "speed_of_service"
    t.integer  "friendliness_of_service"
    t.integer  "ambience"
    t.integer  "cleanliness"
    t.integer  "value_for_money"
    t.text     "comment"
    t.boolean  "completed",                   default: false
    t.integer  "points"
    t.integer  "rewards_pool_after_feedback", default: 0
    t.integer  "user_points_after_feedback",  default: 0
    t.integer  "user_id"
    t.integer  "outlet_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "generated_by"
    t.integer  "recommendation_rating"
    t.float    "bill_amount"
  end

  add_index "feedbacks", ["code"], name: "index_feedbacks_on_code", using: :btree
  add_index "feedbacks", ["outlet_id"], name: "index_feedbacks_on_outlet_id", using: :btree
  add_index "feedbacks", ["user_id"], name: "index_feedbacks_on_user_id", using: :btree

  create_table "global_settings", force: true do |t|
    t.string "setting_name"
    t.string "setting_value"
  end

  create_table "outlet_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "outlets", force: true do |t|
    t.string   "name"
    t.text     "address"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "website_url"
    t.string   "email"
    t.integer  "rewards_pool",        default: 0
    t.integer  "points_redeemed"
    t.string   "phone_number"
    t.string   "open_hours"
    t.boolean  "has_delivery"
    t.boolean  "serves_alcohol"
    t.boolean  "has_outdoor_seating"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "manager_id"
    t.boolean  "disabled",            default: false
  end

  add_index "outlets", ["customer_id"], name: "index_outlets_on_customer_id", using: :btree

  create_table "outlets_cuisine_types", force: true do |t|
    t.integer "outlet_id"
    t.integer "cuisine_type_id"
  end

  add_index "outlets_cuisine_types", ["cuisine_type_id"], name: "index_outlets_cuisine_types_on_cuisine_type_id", using: :btree
  add_index "outlets_cuisine_types", ["outlet_id"], name: "index_outlets_cuisine_types_on_outlet_id", using: :btree

  create_table "outlets_outlet_types", force: true do |t|
    t.integer "outlet_id"
    t.integer "outlet_type_id"
  end

  add_index "outlets_outlet_types", ["outlet_id"], name: "index_outlets_outlet_types_on_outlet_id", using: :btree
  add_index "outlets_outlet_types", ["outlet_type_id"], name: "index_outlets_outlet_types_on_outlet_type_id", using: :btree

  create_table "outlets_staffs", force: true do |t|
    t.integer  "staff_id"
    t.integer  "outlet_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "outlets_staffs", ["outlet_id"], name: "index_outlets_staffs_on_outlet_id", using: :btree
  add_index "outlets_staffs", ["staff_id"], name: "index_outlets_staffs_on_staff_id", using: :btree

  create_table "payment_invoices", force: true do |t|
    t.integer  "kanari_invoice_id"
    t.datetime "receipt_date"
    t.string   "amount_paid"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payment_invoices", ["customer_id"], name: "index_payment_invoices_on_customer_id", using: :btree

  create_table "redemption_logs", force: true do |t|
    t.integer  "user_id"
    t.string   "user_first_name"
    t.string   "user_last_name"
    t.string   "user_email"
    t.integer  "outlet_id"
    t.string   "outlet_name"
    t.integer  "customer_id"
    t.integer  "tablet_id"
    t.integer  "points"
    t.integer  "outlet_points_before"
    t.integer  "outlet_points_after"
    t.integer  "user_points_before"
    t.integer  "user_points_after"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "redemptions", force: true do |t|
    t.integer  "user_id"
    t.integer  "outlet_id"
    t.integer  "points"
    t.integer  "rewards_pool_after_redemption"
    t.integer  "user_points_after_redemption"
    t.integer  "approved_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "approved_at"
  end

  add_index "redemptions", ["outlet_id"], name: "index_redemptions_on_outlet_id", using: :btree
  add_index "redemptions", ["user_id"], name: "index_redemptions_on_user_id", using: :btree

  create_table "social_network_accounts", force: true do |t|
    t.string   "access_token"
    t.string   "access_secret"
    t.string   "refresh_token"
    t.string   "provider"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "social_network_accounts", ["user_id"], name: "index_social_network_accounts_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                             default: "", null: false
    t.string   "encrypted_password",                default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "invitation_token",       limit: 60
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.string   "role"
    t.integer  "points_available",                  default: 0
    t.integer  "points_redeemed"
    t.string   "phone_number"
    t.string   "first_name"
    t.string   "last_name"
    t.date     "date_of_birth"
    t.string   "gender"
    t.string   "location"
    t.integer  "redeems_count"
    t.integer  "feedbacks_count"
    t.datetime "last_activity_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
