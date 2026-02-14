class CreateMovies < ActiveRecord::Migration[7.2]
  def change
    create_table :movies do |t|
      t.integer :tmdb_id, null: false
      t.string :title, null: false
      t.text :overview
      t.string :poster_path
      t.string :backdrop_path
      t.date :release_date
      t.integer :runtime
      t.float :vote_average
      t.integer :ratings_count, default: 0
      t.integer :status, default: 0
      t.float :popularity
      t.string :original_language

      t.timestamps
    end

    add_index :movies, :tmdb_id, unique: true
    add_index :movies, :title
    add_index :movies, :status
    add_index :movies, :release_date
    add_index :movies, :popularity
  end
end
