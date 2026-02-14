class CreateReleaseAlerts < ActiveRecord::Migration[7.2]
  def change
    create_table :release_alerts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :movie, null: false, foreign_key: true
      t.boolean :notified, default: false

      t.timestamps
    end

    add_index :release_alerts, [:user_id, :movie_id], unique: true
  end
end
