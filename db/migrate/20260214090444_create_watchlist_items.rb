class CreateWatchlistItems < ActiveRecord::Migration[7.2]
  def change
    create_table :watchlist_items do |t|
      t.references :user, null: false, foreign_key: true
      t.references :movie, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end

    add_index :watchlist_items, [:user_id, :movie_id], unique: true
  end
end
