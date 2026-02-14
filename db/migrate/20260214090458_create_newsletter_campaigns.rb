class CreateNewsletterCampaigns < ActiveRecord::Migration[7.2]
  def change
    create_table :newsletter_campaigns do |t|
      t.string :subject, null: false
      t.text :body_html
      t.text :body_text
      t.integer :status, default: 0
      t.datetime :scheduled_at
      t.datetime :sent_at
      t.jsonb :segment_filter
      t.references :created_by, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :newsletter_campaigns, :status
  end
end
