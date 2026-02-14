class CreateNewsletterSubscribers < ActiveRecord::Migration[7.2]
  def change
    create_table :newsletter_subscribers do |t|
      t.string :email, null: false
      t.references :user, foreign_key: true, null: true
      t.string :first_name
      t.integer :status, default: 0
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.datetime :subscribed_at
      t.datetime :unsubscribed_at
      t.integer :source, default: 0

      t.timestamps
    end

    add_index :newsletter_subscribers, :email, unique: true
    add_index :newsletter_subscribers, :confirmation_token
  end
end
