# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 17) do

  create_table "apps", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.text     "description"
    t.string   "site_url"
    t.boolean  "self_app",       :default => false
    t.integer  "comments_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "articles", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "excerpt"
    t.text     "body"
    t.integer  "level",                                                        :default => 0
    t.string   "permalink"
    t.integer  "comments_count",                                               :default => 0
    t.integer  "rating_average",  :limit => 10, :precision => 10, :scale => 0, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_tag_list"
  end

  add_index "articles", ["permalink"], :name => "index_articles_on_permalink"

  create_table "comments", :force => true do |t|
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.string   "name"
    t.string   "email"
    t.string   "site_url"
    t.text     "content"
    t.text     "content_html"
    t.string   "user_ip"
    t.string   "user_agent"
    t.string   "referrer"
    t.boolean  "approved",         :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"

  create_table "feed_articles", :force => true do |t|
    t.integer  "user_id"
    t.string   "feed_url"
    t.text     "feed_data"
    t.datetime "feed_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feed_articles", ["user_id"], :name => "index_feed_articles_on_user_id"

  create_table "folders", :force => true do |t|
    t.integer  "user_id"
    t.integer  "parent_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "message_copies", :force => true do |t|
    t.integer  "recipient_id"
    t.integer  "message_id"
    t.integer  "folder_id"
    t.boolean  "deleted",      :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "message_copies", ["folder_id"], :name => "index_message_copies_on_folder_id"
  add_index "message_copies", ["message_id"], :name => "index_message_copies_on_message_id"
  add_index "message_copies", ["recipient_id"], :name => "index_message_copies_on_recipient_id"

  create_table "messages", :force => true do |t|
    t.integer  "author_id"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["author_id"], :name => "index_messages_on_author_id"

  create_table "news", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "comments_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.boolean  "published",  :default => true
    t.integer  "position"
    t.string   "permalink"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quick_tips", :force => true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rates", :force => true do |t|
    t.integer  "user_id"
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.integer  "stars"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rates", ["rateable_id"], :name => "index_rates_on_rateable_id"
  add_index "rates", ["user_id"], :name => "index_rates_on_user_id"

  create_table "screenshots", :force => true do |t|
    t.integer  "app_id"
    t.integer  "size"
    t.string   "content_type"
    t.string   "filename"
    t.integer  "height"
    t.integer  "width"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "screenshots", ["app_id"], :name => "index_screenshots_on_app_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "sitemap_settings", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "xml_location"
    t.string   "username"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sitemap_static_links", :force => true do |t|
    t.string   "url"
    t.string   "name"
    t.float    "priority"
    t.string   "frequency"
    t.string   "section"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sitemap_widgets", :force => true do |t|
    t.string   "widget_model"
    t.string   "index_named_route"
    t.string   "frequency_index"
    t.string   "frequency_show"
    t.float    "priority"
    t.string   "custom_finder"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "uploads", :force => true do |t|
    t.integer  "user_id"
    t.integer  "size"
    t.string   "content_type"
    t.string   "filename"
    t.integer  "height"
    t.integer  "width"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "uploads", ["user_id"], :name => "index_uploads_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 20
    t.string   "name",                      :limit => 100
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "reset_code",                :limit => 40
    t.string   "time_zone",                                :default => "Mexico City"
    t.text     "about"
    t.string   "weblog"
    t.string   "github"
    t.string   "wwr"
    t.string   "linkedin"
    t.string   "os"
    t.string   "text_editor"
    t.string   "msn"
    t.string   "public_email"
    t.string   "twitter"
    t.boolean  "admin",                                    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
