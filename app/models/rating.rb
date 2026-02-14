class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :movie
  has_many :rating_likes, dependent: :destroy
  has_many :likers, through: :rating_likes, source: :user
  has_many :reports, as: :reportable, dependent: :destroy

  validates :score, presence: true, numericality: { greater_than_or_equal_to: 0.5, less_than_or_equal_to: 5.0 }
  validates :user_id, uniqueness: { scope: :movie_id }
  validate :score_step_validation

  scope :with_review, -> { where.not(review_text: [nil, ""]) }
  scope :recent, -> { order(created_at: :desc) }
  scope :most_liked, -> { order(likes_count: :desc) }
  scope :not_reported, -> { where(reported: false) }

  after_save :update_movie_ratings_count
  after_destroy :update_movie_ratings_count

  private

  def score_step_validation
    return unless score
    unless (score * 2) % 1 == 0
      errors.add(:score, "must be in steps of 0.5")
    end
  end

  def update_movie_ratings_count
    movie.update_columns(
      ratings_count: movie.ratings.count,
      vote_average: movie.ratings.average(:score)&.round(2) || 0
    )
  end
end
