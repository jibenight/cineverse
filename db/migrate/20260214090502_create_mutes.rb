class CreateMutes < ActiveRecord::Migration[7.2]
  def change
    create_table :mutes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :muted_by, null: false, foreign_key: { to_table: :users }
      t.integer :scope
      t.references :conversation, foreign_key: true, null: true
      t.integer :duration
      t.text :reason
      t.datetime :expires_at

      t.timestamps
    end

    add_index :mutes, [:user_id, :expires_at]
  end
end
