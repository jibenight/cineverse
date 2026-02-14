class CreateNewsletterPreferences < ActiveRecord::Migration[7.2]
  def change
    create_table :newsletter_preferences do |t|
      t.references :subscriber, null: false, foreign_key: { to_table: :newsletter_subscribers }
      t.integer :category
      t.boolean :enabled, default: true

      t.timestamps
    end

    add_index :newsletter_preferences, [:subscriber_id, :category], unique: true
  end
end
