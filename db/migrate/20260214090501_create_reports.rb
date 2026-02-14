class CreateReports < ActiveRecord::Migration[7.2]
  def change
    create_table :reports do |t|
      t.references :reporter, null: false, foreign_key: { to_table: :users }
      t.string :reportable_type
      t.bigint :reportable_id
      t.integer :reason
      t.text :description
      t.integer :status, default: 0
      t.references :reviewed_by, foreign_key: { to_table: :users }, null: true
      t.datetime :reviewed_at

      t.timestamps
    end

    add_index :reports, [:reportable_type, :reportable_id]
    add_index :reports, :status
  end
end
