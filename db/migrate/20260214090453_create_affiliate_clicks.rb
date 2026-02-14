class CreateAffiliateClicks < ActiveRecord::Migration[7.2]
  def change
    create_table :affiliate_clicks do |t|
      t.references :user, foreign_key: true, null: true
      t.references :movie, null: false, foreign_key: true
      t.integer :provider
      t.datetime :clicked_at
      t.string :user_agent
      t.string :referer
      t.string :ip_hash

      t.timestamps
    end

    add_index :affiliate_clicks, [:user_id, :clicked_at]
    add_index :affiliate_clicks, [:movie_id, :provider]
  end
end
