class CreateCastMembers < ActiveRecord::Migration[7.2]
  def change
    create_table :cast_members do |t|
      t.integer :tmdb_id, null: false
      t.string :name, null: false
      t.string :profile_path
      t.text :biography

      t.timestamps
    end

    add_index :cast_members, :tmdb_id, unique: true
  end
end
