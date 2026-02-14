class NewsletterPreference < ApplicationRecord
  belongs_to :subscriber, class_name: "NewsletterSubscriber"

  enum :category, { weekly_picks: 0, new_releases: 1, community_highlights: 2, deals: 3 }

  validates :category, uniqueness: { scope: :subscriber_id }
end
