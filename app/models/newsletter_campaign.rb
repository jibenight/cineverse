class NewsletterCampaign < ApplicationRecord
  belongs_to :created_by, class_name: "User"
  has_one :newsletter_campaign_stat, foreign_key: :campaign_id, dependent: :destroy
  has_many :newsletter_click_events, foreign_key: :campaign_id, dependent: :destroy

  enum :status, { draft: 0, scheduled: 1, sending: 2, sent: 3, cancelled: 4 }

  validates :subject, presence: true
  validates :body_html, presence: true

  scope :recent, -> { order(created_at: :desc) }

  def stats
    newsletter_campaign_stat
  end
end
