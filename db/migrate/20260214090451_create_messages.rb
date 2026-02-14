class CreateMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :messages do |t|
      t.references :conversation, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :body
      t.integer :message_type, default: 0
      t.references :shared_movie, foreign_key: { to_table: :movies }, null: true
      t.boolean :reported, default: false

      t.timestamps
    end

    add_index :messages, [:conversation_id, :created_at]
  end
end
