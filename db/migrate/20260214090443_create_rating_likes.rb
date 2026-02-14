class CreateRatingLikes < ActiveRecord::Migration[7.2]
  def change
    create_table :rating_likes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :rating, null: false, foreign_key: true

      t.timestamps
    end

    add_index :rating_likes, [:user_id, :rating_id], unique: true
  end
end
