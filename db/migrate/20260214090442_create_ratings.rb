class CreateRatings < ActiveRecord::Migration[7.2]
  def change
    create_table :ratings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :movie, null: false, foreign_key: true
      t.decimal :score, precision: 2, scale: 1, null: false
      t.text :review_text
      t.boolean :spoiler, default: false
      t.integer :likes_count, default: 0
      t.boolean :reported, default: false

      t.timestamps
    end

    add_index :ratings, [:user_id, :movie_id], unique: true
    add_index :ratings, :created_at
  end
end
