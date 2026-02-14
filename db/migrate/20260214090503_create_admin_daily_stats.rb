class CreateAdminDailyStats < ActiveRecord::Migration[7.2]
  def change
    create_table :admin_daily_stats do |t|
      t.date :date, null: false
      t.integer :new_users, default: 0
      t.integer :active_users, default: 0
      t.integer :new_ratings, default: 0
      t.integer :new_messages, default: 0
      t.integer :affiliate_clicks_count, default: 0
      t.decimal :affiliate_revenue_estimate, precision: 10, scale: 2, default: 0
      t.integer :newsletter_subscribers_count, default: 0
      t.integer :newsletter_unsubscribes_count, default: 0
      t.integer :reports_count, default: 0

      t.timestamps
    end

    add_index :admin_daily_stats, :date, unique: true
  end
end
