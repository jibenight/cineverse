class CreateAdminAuditLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :admin_audit_logs do |t|
      t.references :admin, null: false, foreign_key: { to_table: :users }
      t.string :action
      t.string :target_type
      t.bigint :target_id
      t.jsonb :metadata

      t.timestamps
    end

    add_index :admin_audit_logs, [:target_type, :target_id]
  end
end
