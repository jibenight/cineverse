class CreateCinemaPasses < ActiveRecord::Migration[7.2]
  def change
    create_table :cinema_passes do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :provider
      t.string :provider_custom_name
      t.integer :pass_type
      t.boolean :display_on_profile, default: true
      t.boolean :verified, default: false
      t.date :expiration_date

      t.timestamps
    end

    add_index :cinema_passes, [:user_id, :provider]
  end
end
