class CreateGenres < ActiveRecord::Migration[7.2]
  def change
    create_table :genres do |t|
      t.string :name, null: false
      t.integer :tmdb_id, null: false

      t.timestamps
    end

    add_index :genres, :tmdb_id, unique: true
  end
end
