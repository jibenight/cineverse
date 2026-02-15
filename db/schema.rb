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

ActiveRecord::Schema[8.1].define(version: 2026_02_15_020711) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_audit_logs", force: :cascade do |t|
    t.string "action"
    t.bigint "admin_id", null: false
    t.datetime "created_at", null: false
    t.jsonb "metadata"
    t.bigint "target_id"
    t.string "target_type"
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_admin_audit_logs_on_admin_id"
    t.index ["target_type", "target_id"], name: "index_admin_audit_logs_on_target_type_and_target_id"
  end

  create_table "admin_daily_stats", force: :cascade do |t|
    t.integer "active_users", default: 0
    t.integer "affiliate_clicks_count", default: 0
    t.decimal "affiliate_revenue_estimate", precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.date "date", null: false
    t.integer "new_messages", default: 0
    t.integer "new_ratings", default: 0
    t.integer "new_users", default: 0
    t.integer "newsletter_subscribers_count", default: 0
    t.integer "newsletter_unsubscribes_count", default: 0
    t.integer "reports_count", default: 0
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_admin_daily_stats_on_date", unique: true
  end

  create_table "affiliate_clicks", force: :cascade do |t|
    t.datetime "clicked_at"
    t.datetime "created_at", null: false
    t.string "ip_hash"
    t.bigint "movie_id", null: false
    t.integer "provider"
    t.string "referer"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id"
    t.index ["movie_id", "provider"], name: "index_affiliate_clicks_on_movie_id_and_provider"
    t.index ["movie_id"], name: "index_affiliate_clicks_on_movie_id"
    t.index ["user_id", "clicked_at"], name: "index_affiliate_clicks_on_user_id_and_clicked_at"
    t.index ["user_id"], name: "index_affiliate_clicks_on_user_id"
  end

  create_table "badges", force: :cascade do |t|
    t.integer "category"
    t.string "condition_type"
    t.integer "condition_value"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "icon"
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_badges_on_slug", unique: true
  end

  create_table "cast_members", force: :cascade do |t|
    t.text "biography"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "profile_path"
    t.integer "tmdb_id", null: false
    t.datetime "updated_at", null: false
    t.index ["tmdb_id"], name: "index_cast_members_on_tmdb_id", unique: true
  end

  create_table "cinema_passes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "display_on_profile", default: true
    t.date "expiration_date"
    t.integer "pass_type"
    t.integer "provider"
    t.string "provider_custom_name"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.boolean "verified", default: false
    t.index ["user_id", "provider"], name: "index_cinema_passes_on_user_id_and_provider"
    t.index ["user_id"], name: "index_cinema_passes_on_user_id"
  end

  create_table "conversation_participants", force: :cascade do |t|
    t.bigint "conversation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "joined_at"
    t.datetime "last_read_at"
    t.boolean "muted", default: false
    t.integer "role", default: 0
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["conversation_id", "user_id"], name: "index_conversation_participants_on_conversation_id_and_user_id", unique: true
    t.index ["conversation_id"], name: "index_conversation_participants_on_conversation_id"
    t.index ["user_id"], name: "index_conversation_participants_on_user_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "created_by_id", null: false
    t.boolean "is_group", default: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_conversations_on_created_by_id"
  end

  create_table "follows", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "followed_id", null: false
    t.bigint "follower_id", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id"], name: "index_follows_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_follows_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_follows_on_follower_id"
  end

  create_table "genres", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.integer "tmdb_id", null: false
    t.datetime "updated_at", null: false
    t.index ["tmdb_id"], name: "index_genres_on_tmdb_id", unique: true
  end

  create_table "messages", force: :cascade do |t|
    t.text "body"
    t.bigint "conversation_id", null: false
    t.datetime "created_at", null: false
    t.integer "message_type", default: 0
    t.boolean "reported", default: false
    t.bigint "shared_movie_id"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["conversation_id", "created_at"], name: "index_messages_on_conversation_id_and_created_at"
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["shared_movie_id"], name: "index_messages_on_shared_movie_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "movie_cast_members", force: :cascade do |t|
    t.bigint "cast_member_id", null: false
    t.string "character"
    t.datetime "created_at", null: false
    t.bigint "movie_id", null: false
    t.integer "order"
    t.datetime "updated_at", null: false
    t.index ["cast_member_id"], name: "index_movie_cast_members_on_cast_member_id"
    t.index ["movie_id"], name: "index_movie_cast_members_on_movie_id"
  end

  create_table "movie_genres", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "genre_id", null: false
    t.bigint "movie_id", null: false
    t.datetime "updated_at", null: false
    t.index ["genre_id"], name: "index_movie_genres_on_genre_id"
    t.index ["movie_id", "genre_id"], name: "index_movie_genres_on_movie_id_and_genre_id", unique: true
    t.index ["movie_id"], name: "index_movie_genres_on_movie_id"
  end

  create_table "movies", force: :cascade do |t|
    t.string "backdrop_path"
    t.datetime "created_at", null: false
    t.string "original_language"
    t.text "overview"
    t.float "popularity"
    t.string "poster_path"
    t.integer "ratings_count", default: 0
    t.date "release_date"
    t.integer "runtime"
    t.integer "status", default: 0
    t.string "title", null: false
    t.integer "tmdb_id", null: false
    t.datetime "updated_at", null: false
    t.float "vote_average"
    t.index ["popularity"], name: "index_movies_on_popularity"
    t.index ["release_date"], name: "index_movies_on_release_date"
    t.index ["status"], name: "index_movies_on_status"
    t.index ["title"], name: "index_movies_on_title"
    t.index ["tmdb_id"], name: "index_movies_on_tmdb_id", unique: true
  end

  create_table "mutes", force: :cascade do |t|
    t.bigint "conversation_id"
    t.datetime "created_at", null: false
    t.integer "duration"
    t.datetime "expires_at"
    t.bigint "muted_by_id", null: false
    t.text "reason"
    t.integer "scope"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["conversation_id"], name: "index_mutes_on_conversation_id"
    t.index ["muted_by_id"], name: "index_mutes_on_muted_by_id"
    t.index ["user_id", "expires_at"], name: "index_mutes_on_user_id_and_expires_at"
    t.index ["user_id"], name: "index_mutes_on_user_id"
  end

  create_table "newsletter_campaign_stats", force: :cascade do |t|
    t.bigint "campaign_id", null: false
    t.datetime "created_at", null: false
    t.integer "total_bounced", default: 0
    t.integer "total_clicked", default: 0
    t.integer "total_opened", default: 0
    t.integer "total_sent", default: 0
    t.integer "total_unsubscribed", default: 0
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_newsletter_campaign_stats_on_campaign_id"
  end

  create_table "newsletter_campaigns", force: :cascade do |t|
    t.text "body_html"
    t.text "body_text"
    t.datetime "created_at", null: false
    t.bigint "created_by_id", null: false
    t.datetime "scheduled_at"
    t.jsonb "segment_filter"
    t.datetime "sent_at"
    t.integer "status", default: 0
    t.string "subject", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_newsletter_campaigns_on_created_by_id"
    t.index ["status"], name: "index_newsletter_campaigns_on_status"
  end

  create_table "newsletter_click_events", force: :cascade do |t|
    t.bigint "campaign_id", null: false
    t.datetime "clicked_at"
    t.datetime "created_at", null: false
    t.bigint "subscriber_id", null: false
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["campaign_id"], name: "index_newsletter_click_events_on_campaign_id"
    t.index ["subscriber_id"], name: "index_newsletter_click_events_on_subscriber_id"
  end

  create_table "newsletter_preferences", force: :cascade do |t|
    t.integer "category"
    t.datetime "created_at", null: false
    t.boolean "enabled", default: true
    t.bigint "subscriber_id", null: false
    t.datetime "updated_at", null: false
    t.index ["subscriber_id", "category"], name: "index_newsletter_preferences_on_subscriber_id_and_category", unique: true
    t.index ["subscriber_id"], name: "index_newsletter_preferences_on_subscriber_id"
  end

  create_table "newsletter_subscribers", force: :cascade do |t|
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "first_name"
    t.integer "source", default: 0
    t.integer "status", default: 0
    t.datetime "subscribed_at"
    t.datetime "unsubscribed_at"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["confirmation_token"], name: "index_newsletter_subscribers_on_confirmation_token"
    t.index ["email"], name: "index_newsletter_subscribers_on_email", unique: true
    t.index ["user_id"], name: "index_newsletter_subscribers_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "action"
    t.datetime "created_at", null: false
    t.bigint "notifiable_id"
    t.string "notifiable_type"
    t.boolean "read", default: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable_type_and_notifiable_id"
    t.index ["user_id", "read"], name: "index_notifications_on_user_id_and_read"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "rating_likes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "rating_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["rating_id"], name: "index_rating_likes_on_rating_id"
    t.index ["user_id", "rating_id"], name: "index_rating_likes_on_user_id_and_rating_id", unique: true
    t.index ["user_id"], name: "index_rating_likes_on_user_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "likes_count", default: 0
    t.bigint "movie_id", null: false
    t.boolean "reported", default: false
    t.text "review_text"
    t.decimal "score", precision: 2, scale: 1, null: false
    t.boolean "spoiler", default: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["created_at"], name: "index_ratings_on_created_at"
    t.index ["movie_id"], name: "index_ratings_on_movie_id"
    t.index ["user_id", "movie_id"], name: "index_ratings_on_user_id_and_movie_id", unique: true
    t.index ["user_id"], name: "index_ratings_on_user_id"
  end

  create_table "release_alerts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "movie_id", null: false
    t.boolean "notified", default: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["movie_id"], name: "index_release_alerts_on_movie_id"
    t.index ["user_id", "movie_id"], name: "index_release_alerts_on_user_id_and_movie_id", unique: true
    t.index ["user_id"], name: "index_release_alerts_on_user_id"
  end

  create_table "reports", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "reason"
    t.bigint "reportable_id"
    t.string "reportable_type"
    t.bigint "reporter_id", null: false
    t.datetime "reviewed_at"
    t.bigint "reviewed_by_id"
    t.integer "status", default: 0
    t.datetime "updated_at", null: false
    t.index ["reportable_type", "reportable_id"], name: "index_reports_on_reportable_type_and_reportable_id"
    t.index ["reporter_id"], name: "index_reports_on_reporter_id"
    t.index ["reviewed_by_id"], name: "index_reports_on_reviewed_by_id"
    t.index ["status"], name: "index_reports_on_status"
  end

  create_table "static_pages", force: :cascade do |t|
    t.text "body_html"
    t.datetime "created_at", null: false
    t.string "slug", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_static_pages_on_slug", unique: true
  end

  create_table "user_badges", force: :cascade do |t|
    t.bigint "badge_id", null: false
    t.datetime "created_at", null: false
    t.datetime "earned_at"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["badge_id"], name: "index_user_badges_on_badge_id"
    t.index ["user_id", "badge_id"], name: "index_user_badges_on_user_id_and_badge_id", unique: true
    t.index ["user_id"], name: "index_user_badges_on_user_id"
  end

  create_table "user_discounts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "discount_type"
    t.string "label"
    t.boolean "shareable", default: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_user_discounts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "avatar"
    t.text "ban_reason"
    t.datetime "banned_at"
    t.text "bio"
    t.string "city"
    t.datetime "confirmation_sent_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "last_seen_at"
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.boolean "notifications_enabled", default: true
    t.string "provider"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role", default: 0
    t.integer "sign_in_count", default: 0, null: false
    t.integer "theme_preference", default: 0
    t.string "uid"
    t.string "unconfirmed_email"
    t.datetime "updated_at", null: false
    t.string "username"
    t.string "web_push_auth"
    t.string "web_push_endpoint"
    t.string "web_push_p256dh"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "watchlist_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "movie_id", null: false
    t.integer "position"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["movie_id"], name: "index_watchlist_items_on_movie_id"
    t.index ["user_id", "movie_id"], name: "index_watchlist_items_on_user_id_and_movie_id", unique: true
    t.index ["user_id"], name: "index_watchlist_items_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "admin_audit_logs", "users", column: "admin_id"
  add_foreign_key "affiliate_clicks", "movies"
  add_foreign_key "affiliate_clicks", "users"
  add_foreign_key "cinema_passes", "users"
  add_foreign_key "conversation_participants", "conversations"
  add_foreign_key "conversation_participants", "users"
  add_foreign_key "conversations", "users", column: "created_by_id"
  add_foreign_key "follows", "users", column: "followed_id"
  add_foreign_key "follows", "users", column: "follower_id"
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "movies", column: "shared_movie_id"
  add_foreign_key "messages", "users"
  add_foreign_key "movie_cast_members", "cast_members"
  add_foreign_key "movie_cast_members", "movies"
  add_foreign_key "movie_genres", "genres"
  add_foreign_key "movie_genres", "movies"
  add_foreign_key "mutes", "conversations"
  add_foreign_key "mutes", "users"
  add_foreign_key "mutes", "users", column: "muted_by_id"
  add_foreign_key "newsletter_campaign_stats", "newsletter_campaigns", column: "campaign_id"
  add_foreign_key "newsletter_campaigns", "users", column: "created_by_id"
  add_foreign_key "newsletter_click_events", "newsletter_campaigns", column: "campaign_id"
  add_foreign_key "newsletter_click_events", "newsletter_subscribers", column: "subscriber_id"
  add_foreign_key "newsletter_preferences", "newsletter_subscribers", column: "subscriber_id"
  add_foreign_key "newsletter_subscribers", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "rating_likes", "ratings"
  add_foreign_key "rating_likes", "users"
  add_foreign_key "ratings", "movies"
  add_foreign_key "ratings", "users"
  add_foreign_key "release_alerts", "movies"
  add_foreign_key "release_alerts", "users"
  add_foreign_key "reports", "users", column: "reporter_id"
  add_foreign_key "reports", "users", column: "reviewed_by_id"
  add_foreign_key "user_badges", "badges"
  add_foreign_key "user_badges", "users"
  add_foreign_key "user_discounts", "users"
  add_foreign_key "watchlist_items", "movies"
  add_foreign_key "watchlist_items", "users"
end
