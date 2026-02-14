class CreateNewsletterClickEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :newsletter_click_events do |t|
      t.references :campaign, null: false, foreign_key: { to_table: :newsletter_campaigns }
      t.references :subscriber, null: false, foreign_key: { to_table: :newsletter_subscribers }
      t.string :url
      t.datetime :clicked_at

      t.timestamps
    end
  end
end
