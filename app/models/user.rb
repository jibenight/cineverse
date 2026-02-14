class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable

  has_one_attached :avatar

  # Enums
  enum :role, { user: 0, premium: 1, admin: 2 }
  enum :theme_preference, { dark: 0, light: 1 }

  # Associations
  has_many :ratings, dependent: :destroy
  has_many :rated_movies, through: :ratings, source: :movie
  has_many :watchlist_items, dependent: :destroy
  has_many :watchlisted_movies, through: :watchlist_items, source: :movie
  has_many :active_follows, class_name: "Follow", foreign_key: :follower_id, dependent: :destroy
  has_many :passive_follows, class_name: "Follow", foreign_key: :followed_id, dependent: :destroy
  has_many :following, through: :active_follows, source: :followed
  has_many :followers, through: :passive_follows, source: :follower
  has_many :notifications, dependent: :destroy
  has_many :user_badges, dependent: :destroy
  has_many :badges, through: :user_badges
  has_many :conversation_participants, dependent: :destroy
  has_many :conversations, through: :conversation_participants
  has_many :messages, dependent: :destroy
  has_many :release_alerts, dependent: :destroy
  has_many :affiliate_clicks, dependent: :destroy
  has_many :cinema_passes, dependent: :destroy
  has_many :user_discounts, dependent: :destroy
  has_many :rating_likes, dependent: :destroy
  has_many :reports_made, class_name: "Report", foreign_key: :reporter_id, dependent: :destroy
  has_many :mutes, dependent: :destroy

  # Validations
  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 3, maximum: 30 }
  validates :bio, length: { maximum: 500 }, allow_blank: true

  # Scopes
  scope :active, -> { where(banned_at: nil) }
  scope :banned, -> { where.not(banned_at: nil) }
  scope :online, -> { where("last_seen_at > ?", 5.minutes.ago) }

  def banned?
    banned_at.present?
  end

  def online?
    last_seen_at.present? && last_seen_at > 5.minutes.ago
  end

  def follow(other_user)
    active_follows.create(followed: other_user) unless self == other_user
  end

  def unfollow(other_user)
    active_follows.find_by(followed: other_user)&.destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def ratings_count
    ratings.count
  end

  def followers_count
    followers.count
  end

  def following_count
    following.count
  end

end
