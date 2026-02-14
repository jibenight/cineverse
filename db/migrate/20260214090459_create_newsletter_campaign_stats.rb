class CreateNewsletterCampaignStats < ActiveRecord::Migration[7.2]
  def change
    create_table :newsletter_campaign_stats do |t|
      t.references :campaign, null: false, foreign_key: { to_table: :newsletter_campaigns }
      t.integer :total_sent, default: 0
      t.integer :total_opened, default: 0
      t.integer :total_clicked, default: 0
      t.integer :total_bounced, default: 0
      t.integer :total_unsubscribed, default: 0

      t.timestamps
    end
  end
end
