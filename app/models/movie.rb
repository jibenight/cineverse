class Movie < ApplicationRecord
  has_many :movie_genres, dependent: :destroy
  has_many :genres, through: :movie_genres
  has_many :movie_cast_members, dependent: :destroy
  has_many :cast_members, through: :movie_cast_members
  has_many :ratings, dependent: :destroy
  has_many :watchlist_items, dependent: :destroy
  has_many :release_alerts, dependent: :destroy
  has_many :affiliate_clicks, dependent: :destroy
  has_many :messages, foreign_key: :shared_movie_id

  enum :status, { now_playing: 0, upcoming: 1, released: 2 }

  validates :tmdb_id, presence: true, uniqueness: true
  validates :title, presence: true

  scope :now_playing, -> { where(status: :now_playing) }
  scope :upcoming, -> { where(status: :upcoming).order(release_date: :asc) }
  scope :popular, -> { order(popularity: :desc) }
  scope :top_rated, -> { order(vote_average: :desc) }
  scope :recent, -> { order(release_date: :desc) }

  def community_rating
    ratings.average(:score)&.round(1)
  end

end
