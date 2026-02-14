class NewsletterSubscriber < ApplicationRecord
  belongs_to :user, optional: true
  has_many :newsletter_preferences, foreign_key: :subscriber_id, dependent: :destroy
  has_many :newsletter_click_events, foreign_key: :subscriber_id, dependent: :destroy

  enum :status, { pending: 0, active: 1, unsubscribed: 2, bounced: 3 }
  enum :source, { signup: 0, import: 1, manual: 2, footer_form: 3 }

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  before_create :generate_confirmation_token

  scope :confirmed, -> { where(status: :active) }
  scope :subscribed_to, ->(category) {
    joins(:newsletter_preferences).where(newsletter_preferences: { category: category, enabled: true })
  }

  def confirm!
    update(status: :active, confirmed_at: Time.current)
  end

  def unsubscribe!
    update(status: :unsubscribed, unsubscribed_at: Time.current)
  end

  private

  def generate_confirmation_token
    self.confirmation_token = SecureRandom.urlsafe_base64(32)
  end
end
