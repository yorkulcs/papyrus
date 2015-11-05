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

ActiveRecord::Schema.define(version: 20151105154821) do

  create_table "access_codes", force: :cascade do |t|
    t.string   "for",           limit: 255
    t.string   "code",          limit: 255
    t.date     "expires_at"
    t.integer  "student_id"
    t.integer  "created_by_id"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.boolean  "shared",                    default: false
  end

  create_table "acquisition_requests", force: :cascade do |t|
    t.integer  "item_id"
    t.integer  "requested_by_id"
    t.date     "requested_by_date"
    t.integer  "fulfilled_by_id"
    t.date     "fulfilled_by_date"
    t.boolean  "fulfilled",         default: false
    t.boolean  "cancelled",         default: false
    t.integer  "cancelled_by_id"
    t.date     "cancelled_by_date"
    t.text     "notes"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "acquisition_requests", ["item_id"], name: "index_acquisition_requests_on_item_id"

  create_table "announcements", force: :cascade do |t|
    t.text     "message"
    t.string   "audience",   limit: 255
    t.boolean  "active",                 default: false
    t.integer  "user_id"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "attachments", force: :cascade do |t|
    t.string   "name",                 limit: 255
    t.integer  "item_id"
    t.string   "file",                 limit: 255
    t.boolean  "full_text",                        default: false
    t.boolean  "deleted",                          default: false
    t.integer  "user_id",                          default: 0
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.boolean  "is_url",                           default: false
    t.string   "url",                  limit: 255
    t.boolean  "access_code_required",             default: false
  end

  add_index "attachments", ["item_id", "deleted"], name: "index_attachments_on_item_id_and_deleted"

  create_table "audits", force: :cascade do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type",  limit: 255
    t.integer  "associated_id"
    t.string   "associated_type", limit: 255
    t.integer  "user_id"
    t.string   "user_type",       limit: 255
    t.string   "username",        limit: 255
    t.string   "action",          limit: 255
    t.text     "audited_changes"
    t.integer  "version",                     default: 0
    t.string   "comment",         limit: 255
    t.string   "remote_address",  limit: 255
    t.datetime "created_at"
    t.string   "request_uuid",    limit: 255
  end

  add_index "audits", ["associated_id", "associated_type"], name: "associated_index"
  add_index "audits", ["auditable_id", "auditable_type"], name: "auditable_index"
  add_index "audits", ["created_at"], name: "index_audits_on_created_at"
  add_index "audits", ["request_uuid"], name: "index_audits_on_request_uuid"
  add_index "audits", ["user_id", "user_type"], name: "user_index"

  create_table "courses", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.string   "code",        limit: 255
    t.integer  "term_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "items_count",             default: 0, null: false
  end

  add_index "courses", ["term_id"], name: "index_courses_on_term_id"

  create_table "item_connections", force: :cascade do |t|
    t.integer  "item_id"
    t.integer  "student_id"
    t.date     "expires_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "item_connections", ["expires_on", "item_id"], name: "ic_e_i_index"
  add_index "item_connections", ["expires_on", "student_id"], name: "ic_e_s_index"
  add_index "item_connections", ["student_id", "item_id", "expires_on"], name: "ic_s_i_e_index"

  create_table "item_course_connections", force: :cascade do |t|
    t.integer  "item_id"
    t.integer  "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "item_course_connections", ["course_id", "item_id"], name: "icc_c_i_index"

  create_table "items", force: :cascade do |t|
    t.string   "title",                limit: 255
    t.string   "unique_id",            limit: 255
    t.string   "item_type",            limit: 255
    t.string   "callnumber",           limit: 255
    t.string   "author",               limit: 255
    t.integer  "user_id",                          default: 0
    t.string   "isbn",                 limit: 255
    t.string   "published_date",       limit: 255
    t.string   "publisher",            limit: 255
    t.string   "edition",              limit: 255
    t.string   "physical_description", limit: 255
    t.string   "language_note",        limit: 255
    t.string   "source",               limit: 255
    t.string   "source_note",          limit: 255
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "attachments_count",                default: 0, null: false
  end

  add_index "items", ["unique_id"], name: "index_items_on_unique_id"
  add_index "items", ["user_id"], name: "index_items_on_user_id"

  create_table "notes", force: :cascade do |t|
    t.text     "note"
    t.integer  "student_id"
    t.integer  "user_id",    default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "notes", ["student_id"], name: "index_notes_on_student_id"

  create_table "settings", force: :cascade do |t|
    t.string   "var",        limit: 255, null: false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true

  create_table "student_details", force: :cascade do |t|
    t.integer  "student_id"
    t.integer  "student_number"
    t.string   "preferred_phone",              limit: 255
    t.string   "cds_counsellor",               limit: 255
    t.boolean  "format_pdf"
    t.boolean  "format_kurzweil"
    t.boolean  "format_daisy"
    t.boolean  "format_braille"
    t.boolean  "format_word"
    t.boolean  "format_large_print"
    t.text     "format_note"
    t.integer  "transcription_coordinator_id", limit: 255
    t.integer  "transcription_assistant_id"
    t.date     "request_form_signed_on"
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.boolean  "requires_orientation",                     default: true,  null: false
    t.boolean  "orientation_completed",                    default: false, null: false
    t.date     "orientation_completed_at"
    t.boolean  "book_retrieval",                           default: false
    t.boolean  "accessibility_lab_access",                 default: false
    t.string   "cds_counsellor_email",         limit: 255
    t.boolean  "alternate_format_required",                default: true
    t.boolean  "format_other",                 limit: 255
  end

  add_index "student_details", ["student_id"], name: "index_student_details_on_student_id"
  add_index "student_details", ["transcription_assistant_id"], name: "ta_id"
  add_index "student_details", ["transcription_coordinator_id"], name: "tc_id"

  create_table "students", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.string   "email",          limit: 255
    t.string   "username",       limit: 255
    t.string   "student_number", limit: 255
    t.integer  "user_id",                    default: 0
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "terms", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "courses_count",             default: 0, null: false
  end

  add_index "terms", ["end_date"], name: "index_terms_on_end_date"

  create_table "users", force: :cascade do |t|
    t.string   "username",           limit: 255
    t.string   "last_name",          limit: 255
    t.string   "role",               limit: 255
    t.boolean  "inactive",                       default: false
    t.string   "type",               limit: 255
    t.string   "email",              limit: 255
    t.integer  "created_by_user_id"
    t.datetime "email_sent_at"
    t.boolean  "blocked",                        default: false
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.datetime "last_logged_in_at"
    t.string   "first_name",         limit: 255
    t.datetime "last_active_at"
  end

  add_index "users", ["inactive", "role"], name: "index_users_on_inactive_and_role"
  add_index "users", ["inactive"], name: "index_users_on_inactive"
  add_index "users", ["type", "inactive"], name: "index_users_on_type_and_inactive"
  add_index "users", ["username"], name: "index_users_on_username"

end
